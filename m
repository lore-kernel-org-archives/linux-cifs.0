From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] cifs: Invoke id mapping functions (try #16)
Date: Wed, 20 Apr 2011 12:27:31 -0500
Message-ID: <BANLkTimyAx0YmYFuXPT0CdfdD4CYJDD7rw@mail.gmail.com>
References: <1303219269-31144-1-git-send-email-shirishpargaonkar@gmail.com>
	<20110420130752.06d6397d@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110420130752.06d6397d-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Apr 20, 2011 at 12:07 PM, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>=
 wrote:
> On Tue, 19 Apr 2011 08:21:09 -0500
> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>
>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>>
>> rb tree search and insertion routines.
>>
>> A SID which needs to be mapped, is looked up in one of the rb trees
>> depending whether SID is either owner or group SID.
>> If found in the tree, a (mapped) id from that node is assigned to
>> uid or gid as appropriate. =A0If unmapped, an upcall is attempted to
>> map the SID to an id. =A0If upcall is successful, node is marked as
>> mapped. =A0If upcall fails, node stays marked as unmapped and a mapp=
ing
>> is attempted again only after an arbitrary time period has passed.
>>
>> To map a SID, which can be either a Owner SID or a Group SID, key
>> description starts with the string "os" or "gs" followed by SID conv=
erted
>> to a string. Without "os" or "gs", cifs.upcall does not know whether
>> SID needs to be mapped to either an uid or a gid.
>>
>> Nodes in rb tree have fields to prevent multiple upcalls for
>> a SID. =A0Adding and removing nodes is done within global locks.
>> Shrinker routine prunes a node if it has expired but does not prne
>> an expired node if its refcount is not zero (i.e. sid of that node
>> is being mapped via an upcall).
>> Every time an existing node is accessed, its timestamp is updated
>> to prevent it from getting erased.
>>
>> For now, cifs.upcall is only used to map a SID to an id (uid or gid)=
 but
>> it would be used to obtain an SID for an id.
>>
>>
>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsacl.c | =A0332 ++++++++++++++++++++++++++++++++++++++=
+++++++++++----
>> =A0fs/cifs/cifsacl.h | =A0 25 ++++
>> =A02 files changed, 333 insertions(+), 24 deletions(-)
>>
>> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
>> index cad8d9b..bbc29b8 100644
>> --- a/fs/cifs/cifsacl.c
>> +++ b/fs/cifs/cifsacl.c
>
> [...]
>
>> + =A0 =A0 /*
>> + =A0 =A0 =A0* Shrinker could be accessing this entry but it will no=
t
>> + =A0 =A0 =A0* get erased at this point in time and to make it stay =
further,
>> + =A0 =A0 =A0* pretty soon we will take a reference on it only to
>> + =A0 =A0 =A0* release the reference only after upcall returns (or w=
e are
>> + =A0 =A0 =A0* woken up), however longer that upcall may take to ret=
urn.
>> + =A0 =A0 =A0*/
>> + =A0 =A0 if (!test_and_set_bit(SID_ID_PENDING, &psidid->state)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* paidid and its fields are being accesse=
d sans spinlock */
>> + =A0 =A0 =A0 =A0 =A0 =A0 ++psidid->refcount;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Huh? You're incrementing and decrement=
ing the
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0refcount without any locking at all? W=
hat prevents the
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0shrinker from finding the entry just b=
efore you bump
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0the refcount and wiping it out anyway?
>

Becaue we just updated the timestamp so shrinker will not evict the
entry at least for the duration of  SID_MAP_EXPIRE.
The refcount is to account for an lenghty upcall.

>> +struct cifs_sid_id {
>> + =A0 =A0 unsigned int refcount;
>> + =A0 =A0 unsigned long id;
>> + =A0 =A0 unsigned long time;
>> + =A0 =A0 unsigned long retry;
>
> Why, exactly do we need "time" and "retry"? Wouldn't one timestamp
> field do here?
>

One timestamp is to make an entry eligible for eviction and the other
one is to attempt mapping again if previous attempt to map a sid had
failed.

>> + =A0 =A0 unsigned long state;
>> + =A0 =A0 char *sidstr;
>> + =A0 =A0 struct rb_node rbnode;
>> + =A0 =A0 struct cifs_sid sid;
>> +};
>> +
>
> --
> Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
>
