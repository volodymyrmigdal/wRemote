( function _Representative_s_() {

'use strict';

//

let _ = _global_.wTools;
let Parent = null;
let Self = function wRepresentative( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Representative';

// --
// inter
// --

function finit()
{
  let representative = this;
  representative.unform();
  _.Copyable.prototype.finit.call( representative );
}

//

function init( o )
{
  let representative = this;

  _.assert( arguments.length === 1 );

  _.workpiece.initFields( representative );
  Object.preventExtensions( representative );

  if( o )
  representative.copy( o );

  representative.preform();

  return representative;
}

//

function unform()
{
  let representative = this;
  let flock = representative.flock;

  _.assert( flock.representativesMap[ representative.id ] === representative );
  _.assert( flock.connectionToRepresentativeHash.get( representative.connection ) === representative );
  _.asert( representative.role !== 'master' || flock.master === representative );

  if( representative.role === 'master' )
  flock.master = null;
  delete flock.representativesMap[ representative.id ];
  flock.connectionToRepresentativeHash.remove( representative.connection );

}

//

function preform()
{
  let representative = this;
  let flock = representative.flock;

  if( representative.role === null )
  representative.role = _.remote.roleFromAgentPath( representative.agentPath );
  if( representative.agentPath === null )
  representative.agentPath = _.remote.agentPathFromRole( representative.role );
  if( representative.id === null )
  representative.id = _.remote.idFromAgentPath( representative.agentPath );

  _.assert( _.strDefined( representative.role ) );
  _.assert( _.strDefined( representative.agentPath ) );
  _.assert( representative.id >= 1 );
  _.assert( !!representative.connection );
  _.assert( !!representative.flock );
  _.assert( flock.representativesMap[ representative.id ] === undefined );
  _.assert( !flock.connectionToRepresentativeHash.has( representative.connection ) );

  flock.representativesMap[ representative.id ] = representative;
  flock.connectionToRepresentativeHash.set( representative.connection, representative );
  if( representative.role === 'master' )
  flock.master = representative;

}

//

function form()
{
  let representative = this;
  let ready = _.Consequence().take( null );

  return ready;
}

// --
// twin
// --

function handleToTwin( o )
{
  let representative = this;

  if( _.numberIs( o ) || _.strIs( o ) )
  o = { handle : arguments[ 0 ] }

  _.routineOptions( handleToTwin, o );

  _.assert( arguments.length === 1 );

  o.representative = representative;

  let handlers =
  {
    get : representative.TwinProxyGet,
    set : representative.TwinProxySet,
  };

  let proxy = new Proxy( o, handlers );

  return proxy;
}

handleToTwin.defaults =
{
  handle : null,
}

//

function TwinProxyGet( op, fieldName, proxy )
{
  let representative = op.representative;
  let handle = op.handle;
  let flock = representative.flock;

  if( fieldName === twinSymbol )
  return op;
  if( _.symbolIs( fieldName ) )
  return undefined;

  let r =
  {
    [ fieldName ] : function()
    {
      _.assert( this === proxy );
      return flock.agent.requestCall
      ({
        recipient : representative.agentPath,
        object : handle,
        context : this,
        routine : fieldName,
        args : arguments,
      }).ready;
    }
  }

  return r[ fieldName ];
}

//

function TwinProxySet( op, fieldName, value, proxy )
{
  debugger;
  _.assert( 0 );
}

// --
// relations
// --

let twinSymbol = Symbol.for( 'twin' );

let Composes =
{
}

let Associates =
{
  flock : null,
  connection : null,
  id : null,
  role : null,
  agentPath : null,
}

let Restricts =
{
}

let Statics =
{
}

let Forbids =
{
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

  finit,
  init,
  unform,
  preform,
  form,

  // twin

  handleToTwin,
  TwinProxyGet,
  TwinProxySet,

  // relations

  Composes,
  Associates,
  Restricts,
  Statics,
  Forbids,
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
_.EventHandler.mixin( Self );

//

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;
_.remote[ Self.shortName ] = Self;

})();
