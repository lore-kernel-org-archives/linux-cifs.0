From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [GIT] SMB3 Fixes for stable
Date: Fri, 22 Sep 2017 16:15:09 -1000
Message-ID: <CA+55aFypA+5hSWBLLouFTQVuL1-zVeor8+WqkNuT1E4_Y5BAog@mail.gmail.com>
References: <CAH2r5msTomBW-Z8k+_XeUQstNk5JArYsNHYrt+OnhUdh+LKdMQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msTomBW-Z8k+_XeUQstNk5JArYsNHYrt+OnhUdh+LKdMQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Sep 22, 2017 at 3:54 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> Ronnie Sahlberg (1):
>       cifs: show 'soft' in the mount options for hard mounts

That's a very confusing commit message.

There's a missing 'non-' there. The code looks sane, but the commit
message makes zero sense.

              Linus
