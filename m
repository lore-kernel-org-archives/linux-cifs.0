From: Scott Lovenberg <scott.lovenberg@gmail.com>
Subject: Re: [PATCH] RFC cifs-utils: Use autoconf to get kernel headers
Date: Thu, 25 Jul 2013 11:33:59 -0400
Message-ID: <CAFB9KM3cwBkeKtzsQZfi350+WScwcch3UUaT3GkphmJ34Tpoew@mail.gmail.com>
References: <1374515243-21624-1-git-send-email-scott.lovenberg@gmail.com>
	<20130722142752.046fde43@tlielax.poochiereds.net>
	<51EDCC97.9040207@asianux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "sfrench@samba.org" <sfrench@samba.org>,
	linux-cifs <linux-cifs@vger.kernel.org>, samba-technical@lists.samba.org,
	Jeff Layton <jlayton@redhat.com>
To: Chen Gang <gang.chen@asianux.com>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <51EDCC97.9040207@asianux.com>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

On Mon, Jul 22, 2013 at 8:21 PM, Chen Gang <gang.chen@asianux.com> wrote:

> On 07/23/2013 02:27 AM, Jeff Layton wrote:
> > On Mon, 22 Jul 2013 13:47:23 -0400
> > scott.lovenberg@gmail.com wrote:
> >
> >> From: Scott Lovenberg <scott.lovenberg@gmail.com>
> >>
> >> This is an RFC for how we'd use autoconf to get the Linux kernel headers
> >> in include/uapi/linux/cifs.h.  If this is the correct approach, I'll
> >> formalize this patch.  I've never played with autoconf before so this is
> >> completely untested but should (read: might) probably work.
> >>
> >> Signed-off-by: Scott Lovenberg <scott.lovenberg@gmail.com>
> >> ---
> >>  configure.ac |  3 +++
> >>  mount.cifs.c | 27 +++++++++++++++++++--------
> >>  2 files changed, 22 insertions(+), 8 deletions(-)
> >>
> >
> > I think the first step is to do a kernel patch that makes this cifs.h
> > file. I won't commit any sort of patch like this until that's committed
> > first.
> >
> > Also "cifs.h" is somewhat generic. I think you should probably name it
> > a bit more specifically -- maybe include/uapi/linux/cifs/cifs_mount.h...
> >
>
> Do we need add prefix 'CIFS_' for the macro constants to let them in
> their own name space ? (e.g. use 'CIFS_MAX_DOMAIN_SIZE' instead of
> 'MAX_DOMAIN_SIZE').
>
> Thanks.
>
>
>
--
> Chen Gang
>

That's probably a good idea.  I'll be submitting this patch set later today.

-- 
Peace and Blessings,
-Scott.
