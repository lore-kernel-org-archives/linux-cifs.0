From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [GIT] CIFS Fix
Date: Wed, 9 May 2012 15:26:21 -0500
Message-ID: <CAH2r5mt-+i09Y8zndpYGWsrNDax8+cDbVCGk1kg43Hsp=8V+2Q@mail.gmail.com>
References: <CAH2r5muJzvc0xtOuUsLuKLFBSLDK_wQTusG0F3NJzVC0U2qUeQ@mail.gmail.com>
	<CA+55aFy9DHquXRbbx--n3ZVpJ4e7SfWXFF-uVT=meK414oi1ng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFy9DHquXRbbx--n3ZVpJ4e7SfWXFF-uVT=meK414oi1ng-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

History should be clean now - I reset back to the previous rc, merged
with your current tree and then applied the one trivial cifs patch.

The following changes since commit 7ee94d97aafacf5a019b3578e0eae6daa2e2=
bcd5:
  Linus Torvalds (1):
        Merge tag 'fixes-for-linus' of git://git.kernel.org/.../arm/arm=
-soc

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git master

Dan Carpenter (1):
      cifs: fix revalidation test in cifs_llseek()

 fs/cifs/cifsfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


On Wed, May 9, 2012 at 1:19 PM, Linus Torvalds
<torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> On Wed, May 9, 2012 at 6:12 AM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wro=
te:
>> The following changes since commit 5c503f8c0f7550ffe76e388172f898d8d=
11a336e:
>> =A0Steve French (1):
>> =A0 =A0 =A0 =A0Merge branch 'master' of git://git.kernel.org/.../tor=
valds/linux-2.6
>>
>> are available in the git repository at:
>>
>> =A0git://git.samba.org/sfrench/cifs-2.6.git master
>>
>> Dan Carpenter (1):
>> =A0 =A0 =A0cifs: fix revalidation test in cifs_llseek()
>>
>> =A0fs/cifs/cifsfs.c | =A0 =A02 +-
>> =A01 files changed, 1 insertions(+), 1 deletions(-)
>
> This is not at all what I get. I get four commits, three of which are
> rebased versions of the ones I already pulled last week. And two
> pointless back-to-back merges.
>
> Not pulled.
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Linus



--=20
Thanks,

Steve
