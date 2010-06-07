From: Jeff Layton <jlayton@samba.org>
Subject: Re: [PATCH] accept all supported values for
 dir_mode
Date: Mon, 7 Jun 2010 07:24:09 -0400
Message-ID: <20100607072409.76c86d90@corrin.poochiereds.net>
References: <1275547159-30008-1-git-send-email-scott.lovenberg@gmail.com>
	<20100606073303.365579f5@tlielax.poochiereds.net>
	<AANLkTinPR8Mx_AIi59hgTJt-W8zqSg4mqSm0pWpVhFrF@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs@vger.kernel.org, linux-cifs-client@lists.samba.org
To: Scott Lovenberg <scott.lovenberg@gmail.com>
Return-path: <linux-cifs-client-bounces@lists.samba.org>
In-Reply-To: <AANLkTinPR8Mx_AIi59hgTJt-W8zqSg4mqSm0pWpVhFrF@mail.gmail.com>
List-Unsubscribe: <https://lists.samba.org/mailman/options/linux-cifs-client>,
	<mailto:linux-cifs-client-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/linux-cifs-client>
List-Post: <mailto:linux-cifs-client@lists.samba.org>
List-Help: <mailto:linux-cifs-client-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/linux-cifs-client>,
	<mailto:linux-cifs-client-request@lists.samba.org?subject=subscribe>
Sender: linux-cifs-client-bounces@lists.samba.org
Errors-To: linux-cifs-client-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

On Mon, 7 Jun 2010 00:20:14 -0400
Scott Lovenberg <scott.lovenberg@gmail.com> wrote:

> >
> > > -     if (strncmp(token, "dir_mode", 8) == 0)
> > > +     if (strncmp(token, "dir_mode", 4) == 0 || strncmp(token, "dirm", 4)
> > == 0)
> >                                       ^^^^
> > Sigh. But I can confirm that this is similarly broken in the kernel
> > so we have little choice but to live with it here.
> >
> > That's exactly how I felt about this fix.  Do you have any feelings on
> fixing this on both sides to accept only the full strings?  It might cause
> regressions for people, so the kernel patch will probably be pulled by
> Redhat, Suse and Debian (and anyone else backporting kernel patches for long
> term releases) maintainers.
> It seems like the right thing to do, but if it's just going to cause extra
> work and be yanked either way... well, that's one step forward, two
> backwards.
> 
> 

I think we're stuck living with it like this. The maintenance burden on
this sort of thing is fairly low so it's not really a big deal. This is
a good reason why we have to consider user-visible interfaces very
carefully however.

-- 
Jeff Layton <jlayton@samba.org>
