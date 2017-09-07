From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: SMB3: Add xattr support to SMB3 and a bug fix
Date: Thu, 7 Sep 2017 16:19:41 -0700
Message-ID: <CA+55aFzfajbmKGf9C+mwe4gc9bSTokgZK0VZe88DnbEqd9RpQA@mail.gmail.com>
References: <CAH2r5muU8xpsW6WXkMkf_vY1r9u7_ZEsp4fEJykz=nsH=BfGpw@mail.gmail.com>
 <CA+55aFwRv9X4L9kse4ODq=jBzUVqEnHdhi-2tesUpaZW6GbZMg@mail.gmail.com> <CAH2r5mvVJVjFj_uMtxNkteQC=+njXq37o3RNDuJONtaXNfvpeg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvVJVjFj_uMtxNkteQC=+njXq37o3RNDuJONtaXNfvpeg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Sep 7, 2017 at 4:13 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> ok - with git request pull I end up with the branch name rather than
> the  equivalent signed tag in the pull request - so will fix these up
> manually to not show the branch but rather than tag

You either have a really old version of git, or you're using git
request-pull wrong.

You should just state the thing you want me to pull. So it should look
something like

    git request-pull linus git://git.samba.org/sfrench/cifs-2.6.git
4.14-smb3-xattr-enable

and it should do the right thing - which includes verifying that the
tag in question actually exists on the remote end etc.

(Of course, the above assumes that "linus" points to some branch that
is my upstream, I don't actually know what your exact repository
situation is, it might be "origin" or whatever depending on how you
set things up)

            Linus
