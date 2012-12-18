From: Joe Perches <joe@perches.com>
Subject: vfs trace points?: was: cifs: Do not enable debugging code by
 default
Date: Tue, 18 Dec 2012 10:10:04 -0800
Message-ID: <1355854204.30366.11.camel@joe-AO722>
References: <1355737085-6671-1-git-send-email-bp@alien8.de>
	 <CAH2r5mt=4ZoGR_4hP52uHsZabXpPfh1sa1X0GSg6W4=fawNFnA@mail.gmail.com>
	 <20121218071317.01cbc41b@tlielax.poochiereds.net>
	 <20121218144452.GB31255@liondog.tnic>
	 <20121218100702.478fc1b1@tlielax.poochiereds.net>
	 <20121218151904.GC31255@liondog.tnic>
	 <CAH2r5mt622hpU=iC8BL1gvSD-fnjWnE=Qm+pph_AY5ob0zbejQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Borislav Petkov <bp@alien8.de>, Jeff Layton <jlayton@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
	Theodore Tso <tytso@mit.edu>, Al Viro <viro@ZenIV.linux.org.uk>
To: Steve French <smfrench@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAH2r5mt622hpU=iC8BL1gvSD-fnjWnE=Qm+pph_AY5ob0zbejQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Tue, 2012-12-18 at 09:33 -0600, Steve French wrote:
> On Tue, Dec 18, 2012 at 9:19 AM, Borislav Petkov <bp@alien8.de> wrote:
> > On Tue, Dec 18, 2012 at 10:07:02AM -0500, Jeff Layton wrote:
> >> Yeah, not many do, but presumably they'll set it once and forget about
> >> it. Once someone straightens them out, they should rarely break.
> >>
> >> OTOH, the value of defaulting to "N" is pretty low here. Maybe it
> >> would just be best to just drop this patch and have the embedded folks
> >> turn this off on their own.
> >
> > Yeah, sure.
> 
> I am ok with disabling it for embedded, but probably easier to drop
> it.   The real benefit will come when someone familiar with dynamic
> trace points comes up with some good examples for file system(s) and
> the VFS so we can reduce our dependency on static tracing.

I'm fine with requiring embedded to turn this off
where appropriate.

It seems that keeping cifs KERN_DEBUG output for
normal kernels is pretty cost free.  120KB ain't much
these days.

I do think that Al Viro & Ted Ts'o should be pinged
about their vfs tracing thoughts. (cc'd)

MIT seems to bounce my emails, so maybe you could ask
Ted directly.
