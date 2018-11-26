From: Steve French <smfrench@gmail.com>
Subject: Re: linux-next: build warnings after merge of the cifs tree
Date: Sun, 25 Nov 2018 18:31:40 -0600
Message-ID: <CAH2r5mvtFzp=nYK+J92vh9y4tsNLT3rD4a2+mB9LMyWcFN-EHA@mail.gmail.com>
References: <20181126111415.5cf17f39@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: CIFS <linux-cifs@vger.kernel.org>, keescook@google.com,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Sachin Prabhu <sprabhu@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181126111415.5cf17f39@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Both of those cases are intentional fallthroughs and there are
existing comments in the code noting the reasons for them to
fallthrough

(also can see the reasoning for these in the commits which introduced
them from Sachin c369c9a4a7c82) and dde2356c84662)
On Sun, Nov 25, 2018 at 6:14 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi all,
>
> After merging the cifs tree, today's linux-next build (powerpc
> ppc64_defconfig) produced these warnings:
>
> fs/cifs/sess.c: In function 'cifs_select_sectype':
> fs/cifs/sess.c:527:3: warning: this statement may fall through [-Wimplicit-fallthrough=]
>    switch (requested) {
>    ^~~~~~
> fs/cifs/sess.c:540:2: note: here
>   case CIFS_NEGFLAVOR_LANMAN:
>   ^~~~
> fs/cifs/connect.c: In function 'cifs_parse_mount_options':
> fs/cifs/connect.c:1825:8: warning: this statement may fall through [-Wimplicit-fallthrough=]
>     if (!(tmp_end < end && tmp_end[1] == delim)) {
>         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> fs/cifs/connect.c:1832:3: note: here
>    case Opt_pass:
>    ^~~~
>
> Exposed by my use of -Wimplicit-fallthrough
>
> I am not sure why these only turned up now (as opposed to earlier today).
>
> --
> Cheers,
> Stephen Rothwell



-- 
Thanks,

Steve
