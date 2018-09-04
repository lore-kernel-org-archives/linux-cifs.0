From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH] fs/cifs: suppress a string overflow warning
Date: Mon, 3 Sep 2018 21:13:02 -0500
Message-ID: <CAH2r5ms92TpMjA+OKU=qz-ZTK6iRZ-nrv3FFivuhwdQ6z50rDg@mail.gmail.com>
References: <20180903131558.21cdeb35@canb.auug.org.au> <CAH2r5mu99E39iwx=70w6F5MxvNh1MrzbVwTRb2e8dmz9WU52sw@mail.gmail.com>
 <20180904112218.3f7e3337@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180904112218.3f7e3337@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

ok - it looks like it will be a little simpler if I wait
On Mon, Sep 3, 2018 at 8:22 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi Steve,
>
> On Mon, 3 Sep 2018 09:44:17 -0500 Steve French <smfrench@gmail.com> wrote:
> >
> > Merged into cifs-2.6.git for-next
> >
> > Is the message annoying enough on powerpc to merit going into
> > 4.19-rc3, presumably should wait for 4.20?
>
> Up to you, but 4.20 is probably fine.
>
> --
> Cheers,
> Stephen Rothwell



-- 
Thanks,

Steve
