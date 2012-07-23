From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 01/45] CIFS: Make CAP_* checks protocol independent
Date: Mon, 23 Jul 2012 16:14:58 -0500
Message-ID: <CAH2r5msoqOTNm=cEBNaggmpyP4hb+cGJ=JQGoZvHibQVUhYUYA@mail.gmail.com>
References: <1342626541-29872-1-git-send-email-pshilovsky@samba.org>
	<1342626541-29872-2-git-send-email-pshilovsky@samba.org>
	<20120723165947.5fad3d87@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120723165947.5fad3d87-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Jul 23, 2012 at 3:59 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Wed, 18 Jul 2012 19:48:17 +0400
> Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
>
>> Since both CIFS and SMB2 use ses->capabilities (server->capabilities)
>> field but flags are different we should make such checks protocol
>> independent.
>>
>> Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>> ---
>>  fs/cifs/cifsglob.h |   10 ++++++++++
>>  fs/cifs/connect.c  |    6 +++---
>>  fs/cifs/dir.c      |    3 +--
>>  fs/cifs/file.c     |   33 ++++++++++++++++-----------------
>>  fs/cifs/inode.c    |   26 ++++++++++++--------------
>>  fs/cifs/link.c     |    6 +++---
>>  fs/cifs/readdir.c  |   16 ++++++++--------
>>  fs/cifs/smb1ops.c  |    3 +++
>>  fs/cifs/smb2ops.c  |    3 +++
>>  fs/cifs/smb2pdu.c  |    2 ++
>>  fs/cifs/smb2pdu.h  |    3 +++
>>  11 files changed, 64 insertions(+), 47 deletions(-)
>>
>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> index 12b1176..5695693 100644
>> --- a/fs/cifs/cifsglob.h
>> +++ b/fs/cifs/cifsglob.h
>> @@ -258,6 +258,9 @@ struct smb_version_values {
>>       size_t          max_header_size;
>>       size_t          read_rsp_size;
>>       __le16          lock_cmd;
>> +     int             cap_unix;
>> +     int             cap_nt_find;
>> +     int             cap_large_files;
>
> These should probably be unsigned values, and the ses->capabilities and
> server->capabilities flags should be turned into unsigned values as
> well.
>
> For that matter, it's not clear to me why we have capabilities fields
> for both ses and server. I see in one case where they can be different
> (if linuxExtEnabled == 0). Probably they should be converted to always
> use the server one and we get rid of the ses one.

For the non-unix case the server returns caps on negprot (per-socket),
we negotiate them (potentially differently, less than what the server
returned on negprot) on every session setup though.  For proper
reconnection, we probably need to keep both.

For the unix specific capabilities they end up as booleans in the tcon
- as they are negotiated on the tcon (not the socket or smb session)


-- 
Thanks,

Steve
