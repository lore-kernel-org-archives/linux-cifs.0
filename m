From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH 3/4] [SMB3] Fix dereference before null check warning
Date: Wed, 1 Apr 2015 00:00:57 -0500
Message-ID: <CAH2r5ms4p5FYcxW4E1FJ=1DCJstDgOdTDETPEWoW9bxWmJ2O_g@mail.gmail.com>
References: <1427434082-4299-1-git-send-email-smfrench@gmail.com>
 <1427434082-4299-4-git-send-email-smfrench@gmail.com> <20150331204634.4d38c27e@synchrony.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
To: Jeff Layton <jlayton@poochiereds.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150331204634.4d38c27e@synchrony.poochiereds.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Tue, Mar 31, 2015 at 7:46 PM, Jeff Layton <jlayton@poochiereds.net> wrote:
> On Fri, 27 Mar 2015 00:28:01 -0500
> Steve French <smfrench@gmail.com> wrote:
>
>> null tcon is not likely in these paths in current
>> code, but obviously it does clarify the code to
>> check for null (if at all) before derefrencing
>> rather than after.
>>
>> Reported by Coverity (CID 1042666)
>>
>> Signed-off-by: Steve French <smfrench@gmail.com>
>
> I don't get it. Under what circumstances would the tcon ever be NULL
> here? If there aren't any then this is just confusing. It would be
> better to just remove the bogus checks for a NULL tcon instead.

I don't think it really matters much one way or another but I agree it
would be a bug to pass in a null tcon to SMB2_ioctl.

On the other hand ... if there are any paths where tcon might be null
(other than SessionSetup and NegProt and TCon itself) due to bug,
SMB2/SMB3 ioctl/fsctl would be the one since there are various strange
operations (such as security related calls such as validate negotiate
for example) that either call it now or will need to call it as
additional SMB2/SMB3 ioctls are added.  I didn't see any harm in
checking for null tcon, although clearly passing in a null tcon would
be a bug - this is one code path where I don't mind checking since
there are some counterintuitive things which SMB2 ioctl/fsctl protocol
operations do.


>> ---
>>  fs/cifs/smb2pdu.c | 13 ++++++++-----
>>  1 file changed, 8 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
>> index 1b906de..78b329f 100644
>> --- a/fs/cifs/smb2pdu.c
>> +++ b/fs/cifs/smb2pdu.c
>> @@ -1218,7 +1218,7 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
>>       struct smb2_ioctl_req *req;
>>       struct smb2_ioctl_rsp *rsp;
>>       struct TCP_Server_Info *server;
>> -     struct cifs_ses *ses = tcon->ses;
>> +     struct cifs_ses *ses;
>>       struct kvec iov[2];
>>       int resp_buftype;
>>       int num_iovecs;
>> @@ -1233,6 +1233,11 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
>>       if (plen)
>>               *plen = 0;
>>
>> +     if (tcon)
>> +             ses = tcon->ses;
>> +     else
>> +             return -EIO;
>> +
>>       if (ses && (ses->server))
>>               server = ses->server;
>>       else
>> @@ -1296,14 +1301,12 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
>>       rsp = (struct smb2_ioctl_rsp *)iov[0].iov_base;
>>
>>       if ((rc != 0) && (rc != -EINVAL)) {
>> -             if (tcon)
>> -                     cifs_stats_fail_inc(tcon, SMB2_IOCTL_HE);
>> +             cifs_stats_fail_inc(tcon, SMB2_IOCTL_HE);
>>               goto ioctl_exit;
>>       } else if (rc == -EINVAL) {
>>               if ((opcode != FSCTL_SRV_COPYCHUNK_WRITE) &&
>>                   (opcode != FSCTL_SRV_COPYCHUNK)) {
>> -                     if (tcon)
>> -                             cifs_stats_fail_inc(tcon, SMB2_IOCTL_HE);
>> +                     cifs_stats_fail_inc(tcon, SMB2_IOCTL_HE);
>>                       goto ioctl_exit;
>>               }
>>       }
>
>



-- 
Thanks,

Steve
