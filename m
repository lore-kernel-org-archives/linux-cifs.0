From: Ronnie Sahlberg <lsahlber@redhat.com>
Subject: Re: linux-next: manual merge of the cifs tree with Linus' tree
Date: Wed, 13 Jun 2018 23:37:42 -0400 (EDT)
Message-ID: <1114776191.8123837.1528947462817.JavaMail.zimbra@redhat.com>
References: <20180614090135.1d71babb@canb.auug.org.au> <CAH2r5msZ1Zi-MEqCE2eF-7Y50r=Kh4BUVYc6dwORC0iByJ+tBQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        CIFS <linux-cifs@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Aurelien Aptel <aaptel@suse.com>
To: Steve French <smfrench@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAH2r5msZ1Zi-MEqCE2eF-7Y50r=Kh4BUVYc6dwORC0iByJ+tBQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Steve,

Looks good. It builds and seems to work in my testing.
Thanks.

----- Original Message -----
From: "Steve French" <smfrench@gmail.com>
To: "Stephen Rothwell" <sfr@canb.auug.org.au>
Cc: "CIFS" <linux-cifs@vger.kernel.org>, "Linux-Next Mailing List" <linux-next@vger.kernel.org>, "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>, "Kees Cook" <keescook@chromium.org>, "Ronnie Sahlberg" <lsahlber@redhat.com>, "Aurelien Aptel" <aaptel@suse.com>
Sent: Thursday, 14 June, 2018 10:40:43 AM
Subject: Re: linux-next: manual merge of the cifs tree with Linus' tree

Ronnie,

I fixed up that patch and repushed to cifs-2.6.git for-next.  Seems
trivial. Let me know if any issues.

On Wed, Jun 13, 2018 at 6:01 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> Today's linux-next merge of the cifs tree got a conflict in:
>
>   fs/cifs/transport.c
>
> between commit:
>
>   6da2ec56059c ("treewide: kmalloc() -> kmalloc_array()")
>
> from Linus' tree and commit:
>
>   1560d69e21c6 ("cifs: push rfc1002 generation down the stack")
>
> from the cifs tree.
>
> I fixed it up (the latter removed the code modified by the former) and
> can carry the fix as necessary. This is now fixed as far as linux-next
> is concerned, but any non trivial conflicts should be mentioned to your
> upstream maintainer when your tree is submitted for merging.  You may
> also want to consider cooperating with the maintainer of the conflicting
> tree to minimise any particularly complex conflicts.
>
> --
> Cheers,
> Stephen Rothwell



-- 
Thanks,

Steve
