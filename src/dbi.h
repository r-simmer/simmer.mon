#ifndef simmer_mon__dbi_h
#define simmer_mon__dbi_h

#include <simmer/monitor/memory.h>
using namespace simmer;

#define MAX_RECORDS 100000

class DBIMonitor : public MemMonitor {
public:
  DBIMonitor(const std::string& ends, const std::string& releases,
             const std::string& attributes, const std::string& resources,
             RFn& dbClear, RFn& dbAppend)
    : MemMonitor(), n(0), ends(ends), releases(releases), attributes(attributes),
      resources(resources), dbClear(dbClear), dbAppend(dbAppend) {}

  void clear() {
    dbClear();
    MemMonitor::clear();
    n = 0;
  }

  void flush() {
    dbAppend(ends, get_arrivals(false));
    dbAppend(releases, get_arrivals(true));
    dbAppend(attributes, get_attributes());
    dbAppend(resources, get_resources());
    MemMonitor::clear();
    n = 0;
  }

  void record_end(const std::string& name, double start, double end,
                  double activity, bool finished)
  {
    MemMonitor::record_end(name, start, end, activity, finished);
    if (++n >= MAX_RECORDS) flush();
  }

  void record_release(const std::string& name, double start, double end,
                      double activity, const std::string& resource)
  {
    MemMonitor::record_release(name, start, end, activity, resource);
    if (++n >= MAX_RECORDS) flush();
  }

  void record_attribute(double time, const std::string& name,
                        const std::string& key, double value)
  {
    MemMonitor::record_attribute(time, name, key, value);
    if (++n >= MAX_RECORDS) flush();
  }

  void record_resource(const std::string& name, double time, int server_count,
                       int queue_count, int capacity, int queue_size)
  {
    MemMonitor::record_resource(name, time, server_count, queue_count, capacity, queue_size);
    if (++n >= MAX_RECORDS) flush();
  }

private:
  int n;
  std::string ends;
  std::string releases;
  std::string attributes;
  std::string resources;
  RFn dbClear;
  RFn dbAppend;
};

#endif
