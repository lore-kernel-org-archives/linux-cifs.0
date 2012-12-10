From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] [CIFS] fix "disabling echoes and oplocks" on SMB2 mounts
Date: Sun, 9 Dec 2012 19:39:24 -0600
Message-ID: <CAH2r5mvzeXcbV2g4tjtSdqcp5_myebAQkfB9QOt4oPVStveunw@mail.gmail.com>
References: <CAH2r5mun-dOWeYU7SEruZrSBrg=2Sns7+WMXLyt=jnNwq3LFFQ@mail.gmail.com>
	<20121209203329.51c1a76e@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121209203329.51c1a76e-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, Dec 9, 2012 at 7:33 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Sat, 8 Dec 2012 22:41:25 -0600
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> [CIFS] fix "disabling echoes and oplocks" on SMB2 mounts
>>
>> SMB2 and later will return only 1 credit for session setup (phase 1)
>> not just for the negotiate protocol response.  Do not disable
>> echoes and oplocks on session setup (we only need one credit
>> for tree connection anyway) as a resonse with only 1 credit
>> on phase 1 of sessionsetup is expected.
>>
>> Fixes the "CIFS VFS: disabling echoes and oplocks" message
>> logged to dmesg.
>>
>> Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>>  fs/cifs/smb2pdu.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
>> index e7f9dbc..41d9d07 100644
>> --- a/fs/cifs/smb2pdu.c
>> +++ b/fs/cifs/smb2pdu.c
>> @@ -612,7 +612,8 @@ ssetup_ntlmssp_authenticate:
>>
>>       /* BB add code to build os and lm fields */
>>
>> -     rc = SendReceive2(xid, ses, iov, 2, &resp_buftype, CIFS_LOG_ERROR);
>> +     rc = SendReceive2(xid, ses, iov, 2, &resp_buftype,
>> +                       CIFS_LOG_ERROR | CIFS_NEG_OP);
>>
>>       kfree(security_blob);
>>       rsp = (struct smb2_sess_setup_rsp *)iov[0].iov_base;
>>
>
> Looks ok, I guess, but now the name "CIFS_NEG_OP" is somewhat
> confusing. Perhaps it should be changed to something more descriptive?
>
> Acked-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

I don't mind either way (CIFS_NEG_OP or CIFS_SESSION_ESTABLISHMENT_OP
or some such) but think it probably isn't important enough to change -
don't mind if someone wants to pretty up the name later.

-- 
Thanks,

Steve
