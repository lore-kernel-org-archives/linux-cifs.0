From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH] cifs: dir: fix memory leak in cifs_mknod
Date: Fri, 20 Apr 2018 12:48:05 -0500
Message-ID: <67525f3c-f6f2-d1b2-c6eb-66b2315e6530@embeddedor.com>
References: <20180420131919.GA1766@embeddedor.com>
 <CAH2r5mtYQujfeEUpEiE557o3YccD9QwWCTLCJFbBoF7zbYcggQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>
To: Steve French <smfrench@gmail.com>,
        Colin King <colin.king@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAH2r5mtYQujfeEUpEiE557o3YccD9QwWCTLCJFbBoF7zbYcggQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Hi Steve,

On 04/20/2018 12:37 PM, Steve French wrote:
> I noticed a similar problem with the tcon link leak on that (which
> Colin and Gustavo pointed out - thank you!) but also in another return
> statement, so updated the original patch of Ronnie's merging the fixes
> 
> https://git.samba.org/sfrench/cifs-2.6.git/?p=sfrench/cifs-2.6.git;a=commit;h=167bc5de08dc97695f9d5c7069c3e69f409ff80b
> 
> 
> Let me know if you see any problems with it.
> 

Looks correct to me.

Thanks
--
Gustavo

> On Fri, Apr 20, 2018 at 8:19 AM, Gustavo A. R. Silva
> <gustavo@embeddedor.com> wrote:
>> Free allocated memory for full_path and xid before return.
>>
>> Addresses-Coverity-ID: 1468029 ("Resource leak")
>> Fixes: 49162bfde140 ("cifs: do not allow creating sockets except with
>> SMB1 posix exensions")
>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
>> ---
>>   fs/cifs/dir.c | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
>> index f0a759d..71e32d9 100644
>> --- a/fs/cifs/dir.c
>> +++ b/fs/cifs/dir.c
>> @@ -684,8 +684,11 @@ int cifs_mknod(struct inode *inode, struct dentry *direntry, umode_t mode,
>>                  goto mknod_out;
>>          }
>>
>> -       if (!S_ISCHR(mode) && !S_ISBLK(mode))
>> +       if (!S_ISCHR(mode) && !S_ISBLK(mode)) {
>> +               kfree(full_path);
>> +               free_xid(xid);
>>                  return -EPERM;
>> +       }
>>
>>          if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL))
>>                  goto mknod_out;
>> --
>> 2.7.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
