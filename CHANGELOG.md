## 0.14.0 — (unreleased)

No changes yet.


## 0.13.0 — Dec 5th, 2014

### HTTP API Can Be Disabled for Consumers

HTTP API use can be disabled for consumers using the `:enable_http_api_use` config
option (defaults to true).



## 0.12.0 — Nov 25th, 2014

### Explicit Requires

Hutch no longer relies on `Kernel#autoload` to load its key
modules and classes.

Contributed by Pierre-Louis Gottfrois.


### hutch --version No Longer Fails

```
hutch --version
```

no longer fails with an exception.

Contributed by Olle Jonsson.


### Base Class for All Hutch Exceptions

All Hutch exceptions now inherit from `Hutch::Exception`.

Contributed by Pierre-Louis Gottfrois.


## 0.11.0 — Nov 14th, 2014

### Publisher Confirms Support

`:force_publisher_confirms` is a new configuration option that forces `Hutch.publish` to wait
for a confirm for every message published. Note that this **will cause a significant drop in throughput**:

``` ruby
Hutch::Config.set(:force_publisher_confirms, true)
```

`Hutch::Broker#confirm_select` and `Hutch::Broker#wait_for_confirms` are new public API methods
that delegate to their respective `Bunny::Channel` counterparts. `Hutch::Broker#confirm_select`
can be used to handle confirms with a callback instead of waiting:

``` ruby
broker.confirm_select do |delivery_tag, multiple, nack|
  # ...
end
```


### Bunny Update

Bunny is updated to [1.6.0](http://blog.rubyrabbitmq.info/blog/2014/10/31/bunny-1-dot-6-0-is-released/).


## 0.10.0 — Oct 22, 2014

### Configuration via URI

Hutch now supports a new configuration key, `:uri`, which allows
connection configuration via a URI.

Note that since the URI has to include credentials, this option
is not available on the command line.

### Bunny Update

Bunny is updated to `1.5.1`, which mitigates the POODLE attack
by disabling SSL 3.0 where possible.

### Payload in Error Handlers

Error handlers will now have access to message payload.

Contributed by Daniel Farrell.

### Exceptions in Error Handlers Don't Prevent Nacks

Exceptions in error handlers no longer prevent messages from being
`basic.nack`-ed.

### Pid File Support

`:pidfile` is a new configuration option that stores Hutch process
PID in a file at provided path.

Contributed by Rustam Sharshenov.

### More Info on Message

Bunny's `delivery_info`, `properties` and payload are now accessible on `Hutch::Message`.

Contributed by gregory.


### Optional Config Parameters

`Hutch::Config` constructor now accepts an extra hash of optional
configuration parameters.

Contributed by Ignazio Mostallino.


## 0.9.0 — May 13, 2014

### Platform-aware Signal Registration

Hutch will no longer attempt to register signal traps
for signals not supported by the environment (e.g. on by certain OSes).

Contributed by Tobias Matthies.

### TLS Fixes

Hutch now properly passes client TLS key and certificate to
Bunny.

Contributed by Eric Nelson.

### Bunny Update

Bunny is updated to 1.2.x which should offer
[much better latency](https://github.com/ruby-amqp/bunny/pull/187) for
workloads with lots of small messages published frequently.

### More Unit Testing Friendly CLI/Runner

`Hutch::CLI#run` now accepts a parameter and is easier to use
in automated tests.


## 0.8.0 — February 13, 2014

### Uncaught Exceptions Result in Rejected Messages

Uncaught exceptions in consumers now result in Hutch rejecting
messages (deliveries) using `basic.nack`. This way they are [dead lettered](http://www.rabbitmq.com/dlx.html).

Contributed by Garrett Johnson.

### Missing Require

`hutch/consumer.rb` no longer fails to load with the
apps that do not `require "set"`.

Contributed by Garrett Johnson.

### Relaxed Queue Namespace Validation

Namespaces now can include any characters that are valid in RabbitMQ
queue names.

Contributed by Garrett Johnson.

### basic.qos Configuration

It is now possible to configure `basic.qos` (aka channel prefetch) setting
used by Hutch using the `:channel_prefetch` config key.

### Passwords No Longer Logged

Hutch now elides passwords from logs.


## 0.7.0 — January 14, 2014

### Optional HTTP API Use

It is now possible to make Hutch [not use RabbitMQ HTTP
API](https://github.com/gocardless/hutch/pull/69) (e.g. when the
RabbitMQ management plugin that provides it is not available).


### Extra Arguments for Hutch::Broker#publish

Extra options [passed to `Hutch::Broker#publish` will now be propagated](https://github.com/gocardless/hutch/pull/61).


### Content-Type for Messages

Messages published with Hutch now have content type set
to `application/json`.


### Greater Heartbeat Interval

Hutch now uses heartbeat interval of 30, so heartbeats won't interfere with transfers
of large messages over high latency networks (e.g. between AWS availability regions).


### Custom Queue Names

It is now possible to [specify an optional queue name](https://github.com/gocardless/hutch/pull/49):

``` ruby
class FailedPaymentConsumer
  include Hutch::Consumer
  consume 'gc.ps.payment.failed'
  queue_name 'failed_payments'

  def process(message)
    mark_payment_as_failed(message[:id])
  end
end
```

### Global Properties for Publishers

[Global properties can now be specified](https://github.com/gocardless/hutch/pull/62) for publishing:

``` ruby
Hutch.global_properties = proc {
  { app_id: 'api', headers: { request_id: RequestId.request_id } }
}
```

## 0.6.0 - November 4, 2013

- Metadata can now be passed in to `#publish`

## 0.5.1 - October 17, 2013

- Raise an exception when publishing fails

## 0.5.0 - October 17, 2013

- Support for the `--mq-tls-key` and `--mq-tls-cert` configuration options.

## 0.4.5 - October 15, 2013

- No exception raised when hutch is run with no consumers. Instead, a warning
  is logged.
- Internal refactoring: use Bunny's shiny `ConsumerWorkPool#threads`
  attr_reader.

## 0.4.4 - October 12, 2013

- Friendlier Message#inspect, doesn't spew out detailed bunny info.

## 0.4.3 - October 11, 2013

- More autoloading tweaks, all internal modules are now autoloaded.

## 0.4.2 - October 11, 2013

- Autoload the Broker module, which was missed in the previous release.

## 0.4.1 - October 11, 2013

- Autoload internal modules. Fixes regression where the `Config` module was
  not available by simply `require`ing `hutch`.

## 0.4.0 - October 9, 2013

- Support for loading configuration from a file, specified with the `--config`
  command line option.

## 0.3.0 - September 24, 2013

- Add `--[no-]autoload-rails` flag to optionally disable the autoloading of
  Rails apps in the current directory

## 0.2.1 - September 17, 2013

- Fix inconsistency with `mq-tls` option

## 0.2.0 - September 16, 2013

- Support for connecting to RabbitMQ with TLS/SSL. There are two new
  configuration options : `mq-tls` and `mq-api-ssl`.
- JSON message parsing errors are now handled properly.

## 0.1.1 - September 9, 2013

- Relax Bunny dependency specification

## 0.1.0 - September 9, 2013

- Initial release

