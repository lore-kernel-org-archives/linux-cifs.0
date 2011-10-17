From: sean finney <seanius@seanius.net>
Subject: Re: mount.cifs on Win2k8 DFS servers
Date: Mon, 17 Oct 2011 19:11:52 +0200
Message-ID: <20111017171152.GA7102@cobija.connexer.com>
References: <4E9C1876.5090205@keymile.com>
	<20111017123635.GA5978@cobija.connexer.com>
	<4E9C43F6.9050702@keymile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs@vger.kernel.org, jlayton@poochiereds.net,
	samba-technical@lists.samba.org
To: Gerlando Falauto <gerlando.falauto@keymile.com>
Return-path: <samba-technical-bounces@lists.samba.org>
Content-Disposition: inline
In-Reply-To: <4E9C43F6.9050702@keymile.com>
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

Hiya,

On Mon, Oct 17, 2011 at 05:04:22PM +0200, Gerlando Falauto wrote:
> So I guess you're talking about these two little fellas:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=dd61394586dbd9387fe53b325c6807f61734cf89
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=c1508ca23653245266e2e3ab69a8dad464f7a569

IIRC there were 3 or 4 more, though mostly cosmetic/cleanup.  They should
be right before or after those commits.

> 1) I would've expected a more radical fix by skipping to DFS referal
> altogether when server has DFS capabilities, even before trying a
> regular connect, so to make it consistent with smbclient.
> Which (as far as I can tell) has been working like this for a looong time.

I don't think smbclient's behavior is correct either though.  It's
a ways back now, but at the time I compared the existing behavior of
smbclient, a couple different windows clients, and cifs.ko, and none
were really consistant with the other.  The reference doc was not
entirely specific either IIRC.

But based on what the module was already doing, it seemed "right enough"
anyway, and with cleanup/refactoring was kept pretty clean in case
someone wants to improve on it in the future :)

> 2) Shouldn't this/these patch/es also make it into earlier kernels
> as it is a (not-so-negligible) bugfix?

I don't think it's super trivial to backport it before 2.6.38, at least
without massaging the patches and cherry picking a few more commits that
cross paths and/or touch the relevant api's.  But there've been enough
other bugfixes in the cifs code that for our needs we just upgraded to
a backported 2.6.38 kernel and dumped the pre-3.0 cifs commit history
on top of it (we didn't go all the way to 3.0 for entirely uninteresting
reasons, you should just do that if you have the ability).


	sean

-- 
