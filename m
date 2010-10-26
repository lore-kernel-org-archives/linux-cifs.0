From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Subject: Re: getcifsacl/setcifsacl, SID to/fro uid, gid mapping - First attempt
	at a design
Date: Tue, 26 Oct 2010 14:33:42 -0500
Message-ID: <AANLkTi=8Js1iZF2aUrYTHboWX6WYH3=XykU09baFyHwJ@mail.gmail.com>
References: <AANLkTinYBhr6-7uWWsRfnaBPU+S2+LqQfQ_DJkTj1nVm@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
To: linux-cifs@vger.kernel.org,
	samba-technical <samba-technical@lists.samba.org>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <AANLkTinYBhr6-7uWWsRfnaBPU+S2+LqQfQ_DJkTj1nVm@mail.gmail.com>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

On Thu, Oct 14, 2010 at 3:28 PM, Shirish Pargaonkar
<shirishpargaonkar@gmail.com> wrote:
> The goal is to implement tools/utilities named such as getcifsacl and
> setcifsacl,
> similar to getfacl and setfacl respectively.
>
> getcifsacl would be used to display ACL for a file system object which be=
longs
> to a mapped remote share supporting CIFS/NTFS ACL.
> getcifsacl should be supplied with just the file object path and not
> with details such
> as server name/address and share name, user id and password either
> explicitly (as can
> be done for smbcacls command or implicitly e.g. via a configuration file)
>
> cifs vfs client has almost working code to tree connect/disconnect to
> an IPC$ share on
> the server. =A0Cifs vfs client will need an additional functionality to s=
end a
> Trans command which implements a transaction, to implement named pipe API
> TransactNamedPipe (that is the only API that is needed) and a means to
> invoke this
> Trans command i.e. via an ioctl or an xattr.
>
> When a very first tree connection for a very first smb session for an
> smb connection
> succeeds, a tree connection to IPC$ share should occurr, which should suc=
ceed.
> Before the last smb session on an smb connection is removed, the tree con=
nection
> to IPC$ share should be disconnected.
> After reconnect of an smb connection, above should repeat.
>
> When an user issues a command like getcifsacl, getcifsacl invokes getxatt=
r with
> attribute name system.cifsacl which results in cifs client getting
> security descriptor
> from the server which is returned as a blob as attribute value, to the ca=
ller.
>
> Caller parses the blob and for every SID it encounters, makes a
> winbind call, passing
> the SID and expecting a (looked-up) name for that SID. =A0Winbind maps th=
e sid and
> associates that SID with an id.
>
> If winbind can't resolve the name of that SID and returns an error,
> getcifsacl will
> attempt to resolve it by talking to the named pipe lsarpc on the
> server. =A0This would
> involve a sequence of calls such as opening the named pipe, writing to th=
e
> named pipe (e.g. bind rpc), a series of named pipe lsarpc specific
> function calls
> via SMB Trans command to resolve the SID to a name, and finally close
> of that named pipe.
> The RPC calls to the named pipe lsarpc could be part of a newly
> created library or an
> existing library such as librpc. =A0If this name lookup succeeds, the
> SID is mapped to an
> id using winbind. If the name lookup fails, getcifsacl displays the SID.
>
> For the command setcifsacl, either an SID or a name can be provided.
> If an SID is
> provided, there is no name look-up involved. setcifsacl will construct
> an appropriate
> security descriptor and send it as a blob to the cifs vfs client to
> send it to the
> server using set security descriptor to be set which could either succeed=
 or
> fail and caller of the setcifsacl command is notified of the result.
> If a name is specified instead of a SID, setcifsacl shall first asks
> winbind for a SID
> and if it fails, can lookup directly by asking the named pipe lsarpc
> on the server
> for the SID. =A0Once a SID is obtained, a security descriptor is construc=
ted by
> setcifsacl and sent to cifs vfs client. If the SID can't be obtained, set=
cifsacl
> tool/utility fails.
>
> -------------------------------------------------------------------------=
------------
>
> For commands such as ls, cifs client will make an upcall to look up
> SID name and if
> needed map that SID to an id. The mapped id of the Owner SID becomes
> uid and mapped id
> of the Group SID becomes gid of the file system object.
>
> For commands such as chmod or chgrp, the id is looked up for a SID
> from the winbind
> and if winbind fails to provide, the name associated with the id is
> looked up for
> an SID on the named pipe lsarpc on the server. =A0If either the windbind
> or the SID
> lookup =A0(in that order) succeeds, chmod or chgrp command should constru=
ct an
> appropriate security descriptor and send it to the server to set and to e=
ither
> succeed or fail, the results of which are notified to the calling command=
.
> If the SID lookup fails, the chmod/chgrp command should fail at the clien=
t.
>
> -------------------------------------------------------------------------=
-------------
>
> If winbind rpm is not installed or winbind deamon is not running or if
> /etc/nsswitch.conf does not specify winbind for passwd and group, id mapp=
ing
> will not work. =A0(How) Can/should cifs-utils or getcifsacl and setcifsac=
l tools
> specify dependency on all three conditions? Or is there any alternative?
>
> I am not sure if there could be a security descriptor which does not cont=
ain a
> Group SID and if that is the case, what should group id be/default_to?
>
> Should all the SIDs mapped during the life of an smb connection should
> purged from
> winbind when the smb connection is coming down (including when
> reconnect happens)?
> I am not sure if there are any SIDs that should not be purged which
> are universal
> amongst every server, and once mapped, should stay with the winbind
> and should not
> be purged.
> I am not sure whether windbind allows a any qualifier at all or a
> qualifier such as
> server name/address, for id mapping.
>

Some additional comments:



-----------------------------------------------------------------------
getcifsacl

cifs client provides blob to the caller.
caller parses the blob. For every SID it encounters, it makes a call
to get a name for the SID and prints the name instead of the SID and
rest of the ace.


-----------------------------------------------------------------------
setcifsacl

If a SID is specified, caller prepares a blob and supplies it to the
cifs client.
If a name is specified, caller makes a call to get a SID corrosponding
to that name and if available, prepares a blob and supplies it to the
cifs client. If a SID could not be obtained, setcifsacl fails.


-----------------------------------------------------------------------
ls

cifs client makes an upcall to an app with the SID expecting an id
in return.
app makes a call to get the name corrosponding to that SID.
app looks up for that name in pertinent database and if found,
returns id to the cifs client. If not found, adds the name to the
pertinent database and returns the new id to the cifs client.

-----------------------------------------------------------------------
chown/chgrp

cifs client makes an upcall to the app with an id to expecting a SID
in return.
app looks up the id for a name, if found, makes a call to obtain an
associated SID. If the SID exists, app returns SID to the linux client.
If the SID does not exist, call fails.
------------------------------------------------------------------------

The app/cifs client can maintain its own databases
(e.g. one for user /etc/cifsudb and one for group /etc/cifsgdb)
and expect/mandate that databases be specified in the
file /etc/nsswitch.conf.
We can have a .conf file (e.g. /etc/cifsdb.conf) that has entries
similar to winbind to specify range of uids and gids such as

# use uids from 10000 to 20000 for users
idmap uid =3D 10000-20000
# use gids from 10000 to 20000 for groups
idmap gid =3D 10000-20000


Or app/cifs can consider mapping names to ids using winbind.
In that case, we have to rely upon the fact that winbind and samba
rpms are installed, winbind deamon is running, winbind is specified
in the file /etc/nsswitch.conf, and file smb.conf exists with
appropriate mapping specific winbind entries.

Whatever the databases, we need to consider how to purge from those
databases, ids (mapped to names) associated with an smb connection
once that smb connection is either being reconnected or disconnectd.
If there are databases maintained by cifs, it may be easier to do this
i.e. to maintain connection specific mappings and purge those mappings
using the database specific library calls.
