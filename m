From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [GIT] SMB3 fixes
Date: Fri, 7 Jul 2017 17:48:29 -0700
Message-ID: <CA+55aFxMyyKA4yTNuWCBDVjtmObewWHnSKdVNLm7E+QQD_qeng@mail.gmail.com>
References: <CAH2r5mvnUjiMkHUKgDm=cp7SJkZo9JsSYDfDRvkeU7jrsynA9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvnUjiMkHUKgDm=cp7SJkZo9JsSYDfDRvkeU7jrsynA9g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Jul 7, 2017 at 4:13 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> Also let me know if you want me to change how I do signed tags - since I added
> one for this pull request.

Well, you may have added one, but you don't actually indicate it:

>   git://git.samba.org/sfrench/cifs-2.6.git for-next

That "for-next" is not a signed tag.

I do see a signed tag that is named tags/cifs-bug-fixes-for-4.13 and
points to that same commit, so I'll pull that one instead, but please
make your pull requests actually use the tag itself so that I don't
have to go grep for it..

It would also be good to see a few signatures on your public key, but
it seems to be very recent and I guess that will happen over time..

But I've pulled this thing.

As to:

> Another set, which moves the default dialect up from cifs to smb3, and
> improves set ACL and chmod support is still being reviewed, and I will
> try to have that ready next week"

..things are supposed to be ready by the merge window, and if that
thing turns out to be big and scary (or if I just end up being
stressed out about merging) I may not end up pulling it.

                Linus
