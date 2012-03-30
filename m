From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH v3 3/5] CIFS: Separate protocol specific lock type handling
Date: Fri, 30 Mar 2012 15:51:31 +0400
Message-ID: <CAKywueS6X+bxyr6bnP+Sa9Fef2-+hQ1KmGCXRcHQC1828huyOg@mail.gmail.com>
References: <1332848319-6483-1-git-send-email-piastry@etersoft.ru>
	<1332848319-6483-4-git-send-email-piastry@etersoft.ru>
	<20120329153410.5fbe217b@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120329153410.5fbe217b-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

29 =CD=C1=D2=D4=C1 2012=9A=C7. 23:34 =D0=CF=CC=D8=DA=CF=D7=C1=D4=C5=CC=D8=
 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =CE=C1=D0=C9=D3=C1=CC:
> On Tue, 27 Mar 2012 15:38:37 +0400
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>> ---
>> =9Afs/cifs/file.c | =9A 48 +++++++++++++++++++++++++++++++++++++----=
-------
>> =9A1 files changed, 37 insertions(+), 11 deletions(-)
>>
>> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>> index 2e541f0..6e72b1f 100644
>> --- a/fs/cifs/file.c
>> +++ b/fs/cifs/file.c
>> @@ -684,6 +684,30 @@ cifs_locks_delete_block(struct file_lock *waite=
r)
>> =9A =9A =9A unlock_flocks();
>> =9A}
>>
>> +static inline __u32
>> +large_lock_type(void)
>> +{
>> + =9A =9A return LOCKING_ANDX_LARGE_FILES;
>> +}
>> +
>> +static inline __u32
>> +exclusive_lock_type(void)
>> +{
>> + =9A =9A return 0;
>> +}
>> +
>> +static inline __u32
>> +shared_lock_type(void)
>> +{
>> + =9A =9A return LOCKING_ANDX_SHARED_LOCK;
>> +}
>> +
>> +static inline __u32
>> +unlock_lock_type(void)
>> +{
>> + =9A =9A return 0;
>> +}
>> +
>
> I assume that at some point you'll need to add a set of SMB2 equivale=
nt
> ops and then swap them in (probably at NEGOTIATE time)?
>
> If so, would it make sense to bundle these up into a "struct
> smb_protocol_operations" and hang it off the TCP_Server_Info? Then
> you'd just turn the calls below into stuff like:
>
> =9A =9Aserver->proto_ops->large_lock_type
>
> By doing that, it'll be easier to merge in SMB2 code without disturbi=
ng
> the existing code as much. Also, if we find later that we need a new
> set of ops for 2.1, 2.2, 2.3, etc, then we can simply drop in
> replacement operations for them.
>
> I think doing that will be more sound engineering than sprinkling
> "is_smb2" checks all over the place...
>

Yes, moving these functions to a separate transport ops structure that
is going to become a part of TCP_Server_Info will be the next step.

--=20
Best regards,
Pavel Shilovsky.
