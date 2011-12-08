From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [GIT] CIFS Fixes
Date: Thu, 8 Dec 2011 13:20:59 -0800
Message-ID: <CA+55aFy5C8i4vpP2+6k0B1Y0EoDtNzfJvr4YyGOwjewT3GLfyA@mail.gmail.com>
References: <CAH2r5mtW3k8DqsJsJzuYG=VTYD8u2vqKSmbhBvNG6H_E2i_TAg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mtW3k8DqsJsJzuYG=VTYD8u2vqKSmbhBvNG6H_E2i_TAg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Dec 8, 2011 at 11:36 AM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrot=
e:
>
> Jeff Layton (2):
> =A0 =A0 =A0cifs: attempt to freeze while looping on a receive attempt
> =A0 =A0 =A0cifs: check for NULL last_entry before calling cifs_save_r=
esume_key
>
> =A0fs/cifs/connect.c | =A0 =A02 ++
> =A0fs/cifs/readdir.c | =A0 10 ++++++++--
> =A02 files changed, 10 insertions(+), 2 deletions(-)

This is not at all what I get. I get those two, but I also get

  Pavel Shilovsky (1):
      CIFS: Add descriptions to the brlock cache functions

  Steve French (1):
      cifs: Fix sparse warning when calling cifs_strtoUCS

Not pulled, I don't pull from branches that don't match the description=
=2E

                   Linus
