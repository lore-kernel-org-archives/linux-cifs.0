From: Steve French <smfrench@gmail.com>
Subject: Re: linux-next: build failure after merge of the cifs tree
Date: Sun, 24 Jun 2018 19:52:42 -0500
Message-ID: <CAH2r5mu3-5BjqhhG9XO8a3hTW5Gq67WKoVMXRjrcaZ5riFmNfA@mail.gmail.com>
References: <20180625091531.60fe90e9@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: CIFS <linux-cifs@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180625091531.60fe90e9@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Should be ok now - It was missing an update that Aurelien and I worked
on for that patch - so I backed that patch out.   It was also
suggested that that Kconfig parm and #ifdef be removed since SMB3.11
is strongly recommended to be set (which would have avoided this as
well) and will be added to the default list of dialects in the future.
On Sun, Jun 24, 2018 at 6:15 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi all,
>
> After merging the cifs tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>
> fs/cifs/smb2ops.c: In function 'smb311_queryfs':
> fs/cifs/smb2ops.c:1543:11: error: 'struct cifs_tcon' has no member named 'posix_extensions'
>   if (!tcon->posix_extensions)
>            ^~
> At top level:
> fs/cifs/smb2ops.c:1534:1: warning: 'smb311_queryfs' defined but not used [-Wunused-function]
>  smb311_queryfs(const unsigned int xid, struct cifs_tcon *tcon,
>  ^~~~~~~~~~~~~~
>
> Caused by commit
>
>    ("smb3: add support for statfs for smb3.1.1 posix extensions")
>
> # CONFIG_CIFS_SMB311 is not set
>
> I have used the cifs tree from next-20180622 for today.
>
> --
> Cheers,
> Stephen Rothwell



-- 
Thanks,

Steve
