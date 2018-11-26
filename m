From: Kees Cook <keescook@google.com>
Subject: Re: linux-next: build warnings after merge of the cifs tree
Date: Sun, 25 Nov 2018 21:48:10 -0800
Message-ID: <CAGXu5jJDbUZBmbx1ODS72WJKfcv20aMZczq=k4p4OhG8SV0roQ@mail.gmail.com>
References: <20181126111415.5cf17f39@canb.auug.org.au> <CAH2r5mvtFzp=nYK+J92vh9y4tsNLT3rD4a2+mB9LMyWcFN-EHA@mail.gmail.com>
 <20181126115247.53cbf7be@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: smfrench@gmail.com, sprabhu@redhat.com, linux-cifs@vger.kernel.org,
        Linux-Next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181126115247.53cbf7be@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Sun, Nov 25, 2018 at 4:52 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi Steve,
>
> On Sun, 25 Nov 2018 18:31:40 -0600 Steve French <smfrench@gmail.com> wrote:
> >
> > Both of those cases are intentional fallthroughs and there are
> > existing comments in the code noting the reasons for them to
> > fallthrough
> >
> > (also can see the reasoning for these in the commits which introduced
> > them from Sachin c369c9a4a7c82) and dde2356c84662)
>
> I am not questioning that :-)
>
> The gcc warning can be turned off by adding a /* fall through */
> comment at the point the fall through happens.  Kees and others are
> working on the several hundred other places that need annotating.

Right. The goal is to avoid adding any _new_ cases of this. :)

> This one just popped up.

It's already working! :) Thanks Stephen!

-Kees

-- 
Kees Cook
