From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH v2] CIFS: Print message when attempting a mount
Date: Sat, 6 Oct 2018 18:27:42 -0500
Message-ID: <CAH2r5mtHr_EF+s0QwCxcUE_OG7x1yhbBPd0+ZhRXLqbQG4Ct4Q@mail.gmail.com>
References: <ad6b338c900a17c4ecb1655a42b954221f242be2.1538480816.git.rfreire@redhat.com>
 <CAH2r5mtu9XbQfR=QevDqu36ZRYah1hrRGSQyynCfr82PRyunwQ@mail.gmail.com>
 <194690850.32402710.1538508513975.JavaMail.zimbra@redhat.com>
 <CAH2r5ms814MUNWVZNfCTuSO2LQZsmCs5N1nwgdVuhxtMctRE3Q@mail.gmail.com>
 <697659653.32427271.1538515234390.JavaMail.zimbra@redhat.com>
 <CAH2r5muV-vC6twZbNQQ3DHoXJTdaUwhzZi7YH+rhxr0BiMseJQ@mail.gmail.com>
 <633521295.32428133.1538517226400.JavaMail.zimbra@redhat.com>
 <CAH2r5mvXVDfYdJxPKLRJ0QAb_6mUHo4cfhxmkA7c19_GOR0p_Q@mail.gmail.com> <390397598.33123368.1538854368976.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: LKML <linux-kernel@vger.kernel.org>,
        Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Pavel Shilovsky <piastryyy@gmail.com>
To: rfreire@redhat.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <390397598.33123368.1538854368976.JavaMail.zimbra@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Maybe simplest approach to address your request is to add a less noisy
(pr_notice, or pr_info if you prefer) as xfs does in the example you
mentioned:

> xfs_log.c:              xfs_notice(mp, "Mounting V%d Filesystem",

Would be small addition to the following in cifs_debug.h

/* information message: e.g., configuration, major event */
#define cifs_dbg_func(ratefunc, type, fmt, ...)                 \
do {                                                            \
        if ((type) & FYI && cifsFYI & CIFS_INFO) {              \
                pr_debug_ ## ratefunc("%s: "                    \
                                fmt, __FILE__, ##__VA_ARGS__);  \
        } else if ((type) & VFS) {                              \
                pr_err_ ## ratefunc("CIFS VFS: "                \
                                 fmt, ##__VA_ARGS__);           \



On Sat, Oct 6, 2018 at 2:32 PM Rodrigo Freire <rfreire@redhat.com> wrote:
>
> Hi Steve! o/
>
> Appreciate your time and review.
>
> For a v3, what would you like more: a pr_info() straight away in the code
> for the message, or, writing a new cifs_info() function wrapping
> over pr_info, like we have in cifs_dbg (which translates to pr_debug or pr_err)?
>
> Waiting for your comments. Thanks!
>
> ---
> Rodrigo Freire - Principal Technical Account Manager
> GLOBAL CUSTOMER SUCCESS - Partnering with you to help achieve your business goals
> redhat.com | TRIED. TESTED. TRUSTED. | redhat.com/trusted
>
> ----- Original Message -----
>
> > From: "Steve French" <smfrench@gmail.com>
> > To: rfreire@redhat.com
> > Cc: "LKML" <linux-kernel@vger.kernel.org>, "Steve French"
> > <sfrench@samba.org>, "CIFS" <linux-cifs@vger.kernel.org>, "Pavel Shilovsky"
> > <piastryyy@gmail.com>
> > Sent: Saturday, October 6, 2018 4:09:30 PM
> > Subject: Re: [PATCH v2] CIFS: Print message when attempting a mount
>
> > On Tue, Oct 2, 2018 at 4:53 PM Rodrigo Freire <rfreire@redhat.com> wrote:
> > >
> > > Hi hi again Steve \o
> > >
> > > I do see potential for a ftrace rewrite for the cifs_dbg messages.
>
> > Was looking at this on current kernels and debugging mount is probably
> > fine for developers (or users) - plenty of debug messages get printed
> > via the dynamic ftrace points. In practice some would prefer less
> > noisy trace logs so the minimum set for some would be something like
> > this (which already works with current cifs). If we want to add some
> > default log messages on mount to dmesg instead of the trace-cmd log,
> > maybe we should log them at a slightly less noisy level (as we see
> > with xfs and btrfs) so they will be more log friendly




-- 
Thanks,

Steve
