From: Steve French <smfrench@gmail.com>
Subject: Re: cp --reflink and BTRFS_IOC_CLONE
Date: Thu, 17 Oct 2013 09:41:12 -0500
Message-ID: <CAH2r5mv14457HOrOidTQd8g861H83Umecur2m+qpE-T+BzZA0g@mail.gmail.com>
References: <CAH2r5muAM_E6e_Z1M+-Z_0Lqee6ZY9g=Lhf1gdRU=P++6UkHiQ@mail.gmail.com>
	<20131017124846.498280e7@plati.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
To: David Disseldorp <ddiss@suse.de>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20131017124846.498280e7@plati.site>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

I see ocfs2 has a reflink-like call (see ocfs2/ioctl.h)

/* Used to pass 2 file names to reflink. */
struct reflink_arguments {
        __u64 old_path;
        __u64 new_path;
        __u64 preserve;
};
#define OCFS2_IOC_REFLINK       _IOW('o', 4, struct reflink_arguments)

Its format more closely matches SIS_COPYFILE (which I can experiment
with, but probably works even on cifs not just SMB2/SMB3).

On Thu, Oct 17, 2013 at 5:48 AM, David Disseldorp <ddiss@suse.de> wrote:
> On Wed, 16 Oct 2013 15:02:11 -0500
> Steve French <smfrench@gmail.com> wrote:
>
>> Do any other file systems other than btrfs support "cp --reflink" (ie
>> BTRFS_IOC_CLONE).   I am cleaning the patches to cifs.ko to do this at
>> least for SMB2/SMB2.1/SMB3, but I thought that at the kernel file
>> system summit somebody mentioned other in kernel file systems that
>> support the copy offload ioctl that cp --reflink invokes (ie
>> BTRFS_IOC_CLONE).,
>>
>
> I think OCFS2 does via OCFS2_IOC_REFLINK.
>
> Cheers, David



-- 
Thanks,

Steve
