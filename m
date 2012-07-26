From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [GIT] CIFS Fixes
Date: Thu, 26 Jul 2012 14:03:25 -0700
Message-ID: <CA+55aFwNMt9BAvVdkzJTwo6J2r+-kwTH+VeO3ihx8L2wyAYeLg@mail.gmail.com>
References: <CAH2r5mvgQTG2j68c78hiZBMbgNvL3t6iY+d6CWnvtqQXNu2kaw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvgQTG2j68c78hiZBMbgNvL3t6iY+d6CWnvtqQXNu2kaw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Jul 25, 2012 at 12:58 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> The following changes since commit 0ec4f431eb56d633da3a55da67d5c4b88886ccc7:
>
>   locks: fix checking of fcntl_setlease argument (2012-07-23 12:46:01 -0700)
>
> are available in the git repository at:
>
>   git://git.samba.org/sfrench/cifs-2.6.git for-next


I'd *really* prefer to see some summary explanations of what the pull
request actually does.

That's especially true when it adds 7000+ lines of code. Please make
me able to write more than "Pull CIFS fixes".

It would be better still if it was in a signed tag, but even if you
just write a few lines (or a few paragraphs!) about the changes in the
email, it would all be so much better.

                  Linus
