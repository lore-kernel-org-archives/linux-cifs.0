From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH v3 0/2] CIFS: Info-level log support, print message when
 attempting mount.
Date: Sun, 7 Oct 2018 16:06:35 -0500
Message-ID: <CAH2r5msPHc4qup7W=9Pt3PTATtEAN8QcgXQ8Y3r1mZdq1=T7xw@mail.gmail.com>
References: <cover.1538873915.git.rfreire@redhat.com> <CAH2r5muEpTd4xG7oWV5BdA12AOogqscEnFdbUri9C=MFHrN_gQ@mail.gmail.com>
 <9006BE8A-38BB-4249-BEBA-C0DB34560885@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: LKML <linux-kernel@vger.kernel.org>,
        Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Pavel Shilovsky <piastryyy@gmail.com>
To: rfreire@redhat.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <9006BE8A-38BB-4249-BEBA-C0DB34560885@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Sun, Oct 7, 2018 at 3:27 PM Rodrigo Freire <rfreire@redhat.com> wrote:
>
> Thanks Steve! Sorry for overlooking it, whoops.
>
> One more question; what=E2=80=99s your/community opinion on rewriting the=
 existing pr_notice to the new cifs_info?
>
> I could happily retrofit it.

I don't have a strong opinion. The four callers could be changed, but
my gut reaction
is that it is a much higher priority to add useful dynamic tracepoints
(ftrace ie trace-cmd)
to cifs to make it easier to debug real customer problems that are
currently awkward to
debug.   By comparison, even ext4 has over 100 dynamic tracepoints, but lar=
ger
file systems like XFS has 500 (!), and nfs (including SunRPC) has about 100=
.

My guess is that going from our current 28 dynamic trace points (in
cifs.ko) to double
that (at least) will happen as developers add tracepoints to help them
debug real
problems (and of course it will help developers working on future problems =
even
more ...)


> > On 7 Oct 2018, at 15:59, Steve French <smfrench@gmail.com> wrote:
> >
> > Merged into cifs-2.6.git for-next
> >
> > Made a trivial tab/space correction in the patch (pointed out by
> > checkpatch) and then added a trivial followon patch to address a
> > comment/style (trivial)
> > issue pointed out by checkpatch and to add a little more detailed
> > comments about generally when to use each debug function.  If any
> > objections let me know.
> >
> >
> >> On Sun, Oct 7, 2018 at 10:21 AM Rodrigo Freire <rfreire@redhat.com> wr=
ote:
> >>
> >> Hi Steve,
> >> From our conversation over v2, I came out with this v3 patch, which I =
broke
> >> in two commits:
> >>
> >> * The first commit in cifs_debug.h, creating the cifs_info() function.
> >>  - The aim of this commit is to allow to the developer to be able to p=
rint
> >>    informational-level data without having to use pr_info, pr_notice e=
tc,
> >>    in line with other filesystems.
> >>    . One interesting and noteworthy feature of cifs_info() is that it =
is
> >>      transparent to the CIFS_DEBUG config state, either in "y" or "n".
<snip>


--=20
Thanks,

Steve
