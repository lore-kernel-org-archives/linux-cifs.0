From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [GIT] CIFS Fixes
Date: Tue, 20 Sep 2011 00:34:43 -0500
Message-ID: <CAH2r5mts5T3G+mXKcbL00Mx7EXOKoczUeKYwOE8e_qVfc4K3xA@mail.gmail.com>
References: <CAH2r5munKhMMq3GpRp_iEmrb7t3ATZjkubciwTyCe_R2aUdodw@mail.gmail.com>
	<CA+55aFyz1-GeYGHcer9O19XL9LR5CBSK63qz80e-nnTD-195pw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFyz1-GeYGHcer9O19XL9LR5CBSK63qz80e-nnTD-195pw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Sep 20, 2011 at 12:13 AM, Linus Torvalds
<torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> On Mon, Sep 19, 2011 at 9:49 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wr=
ote:
>>
>> =A0git://git.samba.org/sfrench/cifs-2.6.git master
>
> No diffstat? And why is it all totally newly rebased? How much testin=
g
> has any of this gotten?

Sorry - cut and paste error.   Diffstat included below.  This had been
in linux-next since
before the kernel.org problems (thus the delay) and has been tested
against various
versions of Samba and Windows.  I am actually at the Storage Developer
Conference CIFS/SMB2 plugfest testing this week with others on the
Samba team, against various types of servers.  There is one additional
fix that I would like to send later (setting extended security flag by
default, working around a Windows problem we found when upgrading
ntlmv2 default behavior) which I did not include since I want to do
testing against a wider variety of servers here this week.

The following changes since commit 9d037a777695993ec7437e5f451647dea791=
9d4c:
  Linus Torvalds (1):
        Merge branch 'irq-fixes-for-linus' of
git://tesla.tglx.de/git/linux-2.6-tip

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git master

Jeff Layton (1):
      cifs: fix possible memory corruption in CIFSFindNext

Pavel Shilovsky (1):
      CIFS: Fix ERR_PTR dereference in cifs_get_root

Shirish Pargaonkar (1):
      cifs: Fix broken sec=3Dntlmv2/i sec option (try #2)

Steve French (1):
      Fix the conflict between rwpidforward and rw mount options

 fs/cifs/cifsencrypt.c |   54 ++++++++++-------------------------------=
--------
 fs/cifs/cifsfs.c      |   10 +++++---
 fs/cifs/cifssmb.c     |    3 +-
 fs/cifs/connect.c     |    4 +-
 4 files changed, 21 insertions(+), 50 deletions(-)



--=20
Thanks,

Steve
