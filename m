From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/5] CIFS: Add strictcache mount option
Date: Wed, 3 Nov 2010 08:57:15 +0300
Message-ID: <AANLkTinaePkX-MC-QcAfW=F7+qTO6vqV0z+cexH5oyp2@mail.gmail.com>
References: <AANLkTi=04ko7zXRaXvgEBzXFfhhL3QU64gnZOXMPoNOD@mail.gmail.com>
	<4CD0F60E.9040901@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CD0F60E.9040901-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/11/3 Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>:
> On 11/01/2010 01:12 AM, Pavel Shilovsky wrote:
>> Use for switching on strict cache mode. In this mode the
>> client read from the cache all the time it has Oplock Level II,
>> otherwise - read from the server. All written data are stored
>> in the cache, but if the client doesn't have Exclusive Oplock,
>> it writes the data to the server.
>>
>> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> =A0fs/cifs/README =A0 =A0 =A0 | =A0 =A05 +++++
>> =A0fs/cifs/cifs_fs_sb.h | =A0 =A01 +
>> =A0fs/cifs/connect.c =A0 =A0| =A0 =A05 +++++
>> =A03 files changed, 11 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/cifs/README b/fs/cifs/README
>> index ee68d10..8fb6192 100644
>> --- a/fs/cifs/README
>> +++ b/fs/cifs/README
>> @@ -443,6 +443,11 @@ A partial list of the supported mount options f=
ollows:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if oplock (caching token) is granted and=
 held. Note that
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 direct allows write operations larger th=
an page size
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 to be sent to the server.
>> + =A0strictcache =A0 Use for switching on strict cache mode. In this=
 mode the
>> + =A0 =A0 =A0 =A0 =A0 =A0 client read from the cache all the time it=
 has Oplock Level II,
>> + =A0 =A0 =A0 =A0 =A0 =A0 otherwise - read from the server. All writ=
ten data are stored
>> + =A0 =A0 =A0 =A0 =A0 =A0 in the cache, but if the client doesn't ha=
ve Exclusive Oplock,
>> + =A0 =A0 =A0 =A0 =A0 =A0 it writes the data to the server.
>
> Could you remind me where this will be useful? Also, providing the sa=
me
> information in README and mount.cifs man page is useful as well.
>

It is useful when we need to get the only the valida data from the
server. Ex. when the first process writes to the server and the second
reads this in the same time. Due to Samba server can delay mtime
change after writing, we can't trust to mtime and oef checkings and
have to process it according to oplock level we have.

It also works with the mandatory byte-range locking style which
Windows supports - that can let us to make Wine application work
togather with Windows ones on CIFS share where byte-range locks play
sinchronization role.

--=20
Best regards,
Pavel Shilovsky.
