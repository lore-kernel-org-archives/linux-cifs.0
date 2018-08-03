From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH 0/8] cifs compounding
Date: Thu, 2 Aug 2018 17:54:42 -0700
Message-ID: <CAH2r5mu_HeKuGieq10DdV0en8=zRj96HdKVSuzO9UYB1Nh3Ukw@mail.gmail.com>
References: <20180731232618.23586-1-lsahlber@redhat.com> <CAH2r5mvWHnkrQ+zF81_E-KkpVZA3YtZLB_LTk1dmePv0Y3Ktrg@mail.gmail.com>
 <1735951147.19009312.1533165340522.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: CIFS <linux-cifs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
To: Ronnie Sahlberg <lsahlber@redhat.com>,
        samba-technical <samba-technical@lists.samba.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1735951147.19009312.1533165340522.JavaMail.zimbra@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Big performance benefit (for this first narrow case) with Ronnie's
compounding patches (now merged into cifs-2.6.git for-next).   This is
the first code path enabled for smb3 compounding but looks very
promising, if we continue to get such dramatic perf improvements (as
we go forward implementing compounding to help stat, readdir etc.).
Note that we have seen that Macs are quite aggressive about
compounding in SMB3 (and Windows benefits a lot as well) so there a
quite a few future code paths that we can optimize.  It obviously
helps with more than network latency though, it can reduce server load
as well.  Additional improvements in handle caching and directory
leases (currently only implemented for the root directory) will also
be a big win in the future as they are extended in cifs.ko for SMB3.

I did some primitive tests with and without Ronnie's patch and it was
from 40% to 2000% slower before his patch (on the wire).   I tried df
and stat -f.  Note that stat -f shows the greater benefit (only one
compounded request on the with his patch, instead of two requests only
one of which is compounded with df)

Without his patch:
local (fast network, to Samba)  ~2/100ths of a second
remote (Azure, encrypted) - 16th/100ths to 17/100ths of a second

With his patch
local (fast network, to Samba) ~1/1000 of a second
remote (Azure, encrypted) ~6/100ths to ~12/100ths (stat -f vs. df)

so basically "stat -f" on the root goes from 3 requests to 1 send on
the wire, while df goes from 4 requests to 2.

Good job Ronnie!
On Wed, Aug 1, 2018 at 4:15 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> Updated patch.
>
> Thanks
>
> ----- Original Message -----
> From: "Steve French" <smfrench@gmail.com>
> To: "Ronnie Sahlberg" <lsahlber@redhat.com>
> Cc: "CIFS" <linux-cifs@vger.kernel.org>
> Sent: Wednesday, 1 August, 2018 5:19:36 PM
> Subject: Re: [PATCH 0/8] cifs compounding
>
> I have merged the first three tentatively, but did a little cleanup of
> scripts/checkpatch warnings (see attached lightly updated patches).
> For patch four (update receive encrypted standard) I noticed some
> endian errors - can you fix them (when I built them I got these sparse
> warnings)
>
>   CHECK   /home/sfrench/cifs-2.6/fs/cifs/smb2ops.c
> /home/sfrench/cifs-2.6/fs/cifs/smb2ops.c:3075:66: warning: restricted
> __le32 degrades to integer
> /home/sfrench/cifs-2.6/fs/cifs/smb2ops.c:3076:49: warning: restricted
> __le32 degrades to integer
> /home/sfrench/cifs-2.6/fs/cifs/smb2ops.c:3079:68: warning: restricted
> __le32 degrades to integer
> /home/sfrench/cifs-2.6/fs/cifs/smb2ops.c:3080:49: warning: restricted
> __le32 degrades to integer
> /home/sfrench/cifs-2.6/fs/cifs/smb2ops.c:3101:28: warning: invalid
> assignment: -=
> /home/sfrench/cifs-2.6/fs/cifs/smb2ops.c:3101:28:    left side has
> type unsigned int
> /home/sfrench/cifs-2.6/fs/cifs/smb2ops.c:3101:28:    right side has
> type restricted __le32
> /home/sfrench/cifs-2.6/fs/cifs/smb2ops.c:3108:28: warning: restricted
> __le32 degrades to integer
>
> Attached are the lightly updated versions of the patches that reduce
> the checkpatch warnings - but can you cleanup the endian errors in
> patch 4.
>
>
>
>
> On Tue, Jul 31, 2018 at 6:26 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
> >
> > Steve, All
> >
> > An updated patch series based on Pavels feedback.
> >
>
>
> --
> Thanks,
>
> Steve



--
Thanks,

Steve
