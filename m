From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 3/8] cifs: add CIFSCheckMFSymlink() as stub
Date: Thu, 05 Aug 2010 17:40:36 +0530
Message-ID: <4C5AAA3C.1000304@suse.de>
References: <AANLkTinJ1WRBT_Q3TqOZdMQExV66LSUAPG4c01yK-XRK@mail.gmail.com>	<1280931109-22380-4-git-send-email-metze@samba.org> <20100804103748.521163e6@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100804103748.521163e6-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 08/04/2010 08:07 PM, Jeff Layton wrote:
> On Wed,  4 Aug 2010 16:11:44 +0200
> Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> 
>> Signed-off-by: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>> ---
>>  fs/cifs/cifsproto.h |    3 +++
>>  fs/cifs/inode.c     |    7 +++++++
>>  fs/cifs/link.c      |    8 ++++++++
>>  3 files changed, 18 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
>> index 2eaebbd..e94e095 100644
>> --- a/fs/cifs/cifsproto.h
>> +++ b/fs/cifs/cifsproto.h
>> @@ -409,4 +409,7 @@ extern int CIFSSMBSetPosixACL(const int xid, struct cifsTconInfo *tcon,
>>  extern int CIFSGetExtAttr(const int xid, struct cifsTconInfo *tcon,
>>  			const int netfid, __u64 *pExtAttrBits, __u64 *pMask);
>>  extern void cifs_autodisable_serverino(struct cifs_sb_info *cifs_sb);
>> +extern int CIFSCheckMFSymlink(struct cifs_fattr *fattr,
>> +		const unsigned char *path,
>> +		struct cifs_sb_info *cifs_sb, int xid);
>>  #endif			/* _CIFSPROTO_H */
>> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
>> index a15b3a9..c4121de 100644
>> --- a/fs/cifs/inode.c
>> +++ b/fs/cifs/inode.c
>> @@ -661,6 +661,13 @@ int cifs_get_inode_info(struct inode **pinode,
>>  	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL)
>>  		cifs_sfu_mode(&fattr, full_path, cifs_sb, xid);
>>  
>> +	/* query for SFU type info if supported and needed */
>> +	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS) {
>> +		tmprc = CIFSCheckMFSymlink(&fattr, full_path, cifs_sb, xid);
>> +		if (tmprc)
>> +			cFYI(1, "CIFSCheckMFSymlink: %d", tmprc);
>> +	}
>> +
> 
> 		^^^^^^^^^^^^^^
> 
> This only seems to touch the codepath without posix extensions. What
> about when unix extensions are enabled? The previous patch seems to
> indicate that the behavior is that mfsymlinks are always used when that
> mount option is used even if unix extensions are enabled. If so, then I
> think you'll need a similar change in cifs_get_inode_info_unix.
> 

I initially thought so. But, looking again - there is no point in
querying for SFU type info if unix extensions are enabled..?

Thanks,


-- 
Suresh Jayaraman
