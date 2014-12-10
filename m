From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [GIT PULL] CIFS Fixes
Date: Wed, 10 Dec 2014 15:40:46 -0800
Message-ID: <CA+55aFzSTqAHhQSUjgQ+6wfD+q614SbEhQuBYhfUaQsmAmGrkQ@mail.gmail.com>
References: <CAH2r5muu_0byHxGJeKxmFinRSv4Aiduj=7U5ysyP-3MzK7e+HQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5muu_0byHxGJeKxmFinRSv4Aiduj=7U5ysyP-3MzK7e+HQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Dec 9, 2014 at 7:18 AM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Mostly cifs cleanup but also a few cifs fixes.

Hmm. The diffstat is truncated:

>  MAINTAINERS          |  3 +-
>  fs/cifs/cifs_debug.c | 77 ++++++++++++++++++++++------------------------------
>  fs/cifs/cifs_debug.h |  7 ++---
>  fs/cifs/cifsfs.h     |  2 +-
>  fs/cifs/connect.c    | 51 ++++++++++++----------------------
>  fs/cifs/misc.c       | 32 ++--------------------
>  fs/cifs/readdir.c    |  4 ---
>  fs/cifs/sess.c       |  5 ++++
>  fs/cifs/smb2ops.c    | 63 +++++++++++++++++++++++++++++++++++++++++-
>  fs/cifs/smb2pdu.c    |  3 +-

that is missing the last three lines that somehow got truncated
(smb2pdu.h, transport.c and the files/lines changed summary line).

My shortlog matches, so I'm taking it, but please be more careful.

                   Linus
