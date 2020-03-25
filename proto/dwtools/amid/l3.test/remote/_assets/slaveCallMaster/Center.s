( function _Center_s_() {

'use strict';

var _ToolsPath_ = process.env._TOOLS_PATH_;
var _RemotePath_ = process.env._REMOTE_PATH_;
var _DisconnectDelay_ = Number( process.env._DISCONNECT_DELAY_ ) || 10000;

if( typeof module !== 'undefined' )
{
  var _ = require( _ToolsPath_ );
  _.include( _RemotePath_ );
  module.exports = _;
}

//

var _ = _global_.wTools;
let Parent = null;
let Self = function wStarterCenter( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Center';

// --
// routine
// --

function unform()
{
  let center = this;
  flock.close();
}

//

function form()
{
  let center = this;
  let flock = center.flock = _.remote.Flock
  ({
    entryPath : __filename,
  });

  flock.localHandlesAdd({ objects : { center : center } });

  flock.on( 'connectEnd', () =>
  {

    flock.send( `from ${flock.role}` );

    if( flock.role === 'slave' )
    _.time.out( _DisconnectDelay_, () =>
    {
      flock.close();
      _.procedure.terminationReport();
    });

  });

  return flock.form()
  .then( ( arg ) =>
  {
    if( flock.role !== 'slave' )
    return null;
    let masterCenter = flock.master.handleToTwin( 'center' );
    return masterCenter.doSomething();
  })
  .then( ( got ) =>
  {
    if( flock.role !== 'slave' )
    return null;
    flock.log( 0, `doSomething ${got}` );
    return got;
  })
  ;

  // .then( ( arg ) =>
  // {
  //   debugger;
  //   return center.remote.slaveOpenSlave();
  // })
  // .then( ( slaveFlock ) =>
  // {
  //   debugger;
  //   center.slaveFlock = slaveFlock;
  //   center.slaveCenter = slaveFlock.objectGet( 'center' );
  //   return center.slaveCenter.doSomething();
  // });
  // .then( ( got ) =>
  // {
  //   debugger;
  //   center.flock.log( 0, `doSomething ${got}` );
  // });

}

//

function Exec()
{
  let center = new this.Self();
  return center.exec();
}

//

function exec()
{
  let center = this;
  return center.form();
}

// --
//
// --

function doSomething()
{
  let center = this;
  let result = center.field1 + center.field2;
  center.flock.log( 0, `doSomething ${result}` );
  return result;
}

// --
// relations
// --

let Composes =
{
  field1 : 1,
  field2 : 2,
}

let Associates =
{
  flock : null,
  slave : null,
}

let Restricts =
{
}

let Statics =
{
  Exec,
}

let Accessor =
{
}

// --
// prototype
// --

let Proto =
{

  // inter

  unform,
  form,
  Exec,
  exec,

  //

  doSomething,

  //

  Composes,
  Associates,
  Restricts,
  Statics,
  Accessor,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

_.Copyable.mixin( Self );

//

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

if( !module.parent )
Self.Exec();

})();
