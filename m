From: Steve French <smfrench@gmail.com>
Subject: Re: linux-next: build failure after merge of the cifs tree
Date: Thu, 31 May 2018 19:19:27 -0500
Message-ID: <CAH2r5mt9YaodzbsnnD1rr68xrr7BRQY9MWYpLzeRmk37Z-X68Q@mail.gmail.com>
References: <20180601100922.56e98097@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: CIFS <linux-cifs@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180601100922.56e98097@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

sorry about that - missing

#ifdef CONFIG_CIFS_SMB311
#endif

around that.  It is fixed now and repushed to cifs-2.6.git for-next

otherwise requires SMB311 to be enabled in the build

On Thu, May 31, 2018 at 7:09 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> After merging the cifs tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>
> fs/cifs/connect.c: In function 'cifs_mount':
> fs/cifs/connect.c:3967:10: error: 'struct cifs_tcon' has no member named 'posix_extensions'
>   if (tcon->posix_extensions)
>           ^~
>
> Caused by commit
>
>   12a778233fc4 ("smb3: Add posix create context for smb3.11 posix mounts")
>
> # CONFIG_CIFS_SMB311 is not set
>
> I have used the cifs tree from next-20180531 for today.
>
> --
> Cheers,
> Stephen Rothwell



-- 
Thanks,

Steve
