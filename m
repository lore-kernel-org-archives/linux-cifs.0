From: Steve French <smfrench@gmail.com>
Subject: Re: config files and how to have persistent Linux kernel Driver/File
 System configuration info saved
Date: Thu, 28 Jun 2018 18:24:59 -0500
Message-ID: <CAH2r5mui9WLBC6ne+iqVeYDGKEMKTabHPTf57STM9_aPGfM0sA@mail.gmail.com>
References: <CAH2r5msV1hBAGgqtMFh6P=OGPV3RKjVAER=5bg-6Y+vW5BEJwQ@mail.gmail.com>
 <20180628225857.GB1231@thunk.org> <CAN05THStuq+RLzb_oNiD2TvN6MjMMnTdCxNiHuYWHRueQ46=_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Theodore Tso <tytso@mit.edu>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>
To: ronnie sahlberg <ronniesahlberg@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAN05THStuq+RLzb_oNiD2TvN6MjMMnTdCxNiHuYWHRueQ46=_A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Thu, Jun 28, 2018 at 6:21 PM ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
>
> On Fri, Jun 29, 2018 at 8:58 AM, Theodore Y. Ts'o via samba-technical
> <samba-technical@lists.samba.org> wrote:
> > On Thu, Jun 28, 2018 at 05:37:15PM -0500, Steve French wrote:
> >> Ronnie brought up an interesting point about the problems consistently
> >> configuring file systems (or any Linux module for that matter) so that
> >> reboot doesn't wipe away security or performance tuning changes.
> >
> > In general it's considered best practice to make the file system
> > auto-tune itself as much as possible, because the sad fact is that
> > 99.9999% of the customers aren't going to bother to add any tuning
> > parameters.  So there hasn't been a push to try to create something
> > more complex, because it's generally not needed.
>
> True, but in these cases I think we are more looking at server or
> mountpoint specific options than
> actual fs tuning.
>
> For example nfsmount.conf can be used to say "only use NFSv4 when
> accessing server abc" etc.
> For the case of CIFS I could imagine that an administrator might want
> to set "disable smb1 protocol globally"

Or perhaps
  "disable smb1 on " ... various public networks but allow it on
private networks

-- 
Thanks,

Steve
