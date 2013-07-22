From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH] cifs-utils: Correct max string lengths
Date: Mon, 22 Jul 2013 06:53:17 -0400
Message-ID: <20130722065317.11cd4ffd@corrin.poochiereds.net>
References: <1374269172-4964-1-git-send-email-scott.lovenberg@gmail.com>
	<CAH2r5msAt8ZuXYdNzufB3BOah7f2ywyi3EgbS14ahESWe1BMRw@mail.gmail.com>
	<C1A22AEB-8028-4D35-9924-83C9D0DD2D5D@gmail.com>
	<CAH2r5msVGjeJss9vXd-8H3yn58=8q=njTgWjBrssov_MBT-XLg@mail.gmail.com>
	<8FB3EB95-C367-4DE7-935C-37C7295F7D53@gmail.com>
	<20130720064344.42d73b04@tlielax.poochiereds.net>
	<6D61AEAF-9EE2-4F99-BA76-F186A76312E0@gmail.com>
	<51EC8D09.1020504@asianux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "sfrench@samba.org" <sfrench@samba.org>, Steve French <smfrench@gmail.com>,
	"samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
To: Chen Gang <gang.chen@asianux.com>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <51EC8D09.1020504@asianux.com>
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

On Mon, 22 Jul 2013 09:38:17 +0800
Chen Gang <gang.chen@asianux.com> wrote:

> On 07/20/2013 11:24 PM, Scott Lovenberg wrote:
> > 
> > 
> > Sent from my iPod
> > 
> > On Jul 20, 2013, at 6:43, Jeff Layton <jlayton@redhat.com> wrote:
> > 
> >> On Fri, 19 Jul 2013 22:44:22 -0400
> >> Scott Lovenberg <scott.lovenberg@gmail.com> wrote:
> >>
> >>> On Jul 19, 2013, at 22:34, Steve French <smfrench@gmail.com> wrote:
> >>>
> >>>> Leaving Max share length at 256 is fine with me
> >>> Works for me. Should this be fixed kernel side?
> >>
> >> Yes, I think that would make sense. Scott, I assume you'll send a v2 of
> >> this patch that preserves the share length at 256?
> >>
> >> Once that's done, the ideal thing here would be to move these
> >> definitions in the kernel to a separate header file that lives under
> >> include/linux. Then we could have autoconf in cifs-utils look for that
> >> header and use the #defines from that instead if it's present.
> >>
> >> That way we won't be so reliant on keeping the kernel and cifs-utils in
> >> sync...
> > 
> > Yeah. I'll respin and send tomorrow. I have a wedding to attend this afternoon.  Using autoconf would be terrific and I'm completely on board with that idea. 
> > 
> 
> Is it better to let the new header file in "include/uapi/linux" ? It
> belongs to the interface between user mode and kernel mode.
> 

That's more of a long-term fix. We'll still need to build cifs-utils
against kernel headers that don't contain that header file, so fixing
the lengths here is needed anyway.

Once this patch goes in, adding a header in include/uapi/linux that
holds these lengths (and any others that the mount helper and cifs.ko
need to share) would be helpful. Then we could simply look for that
file at autoconf time, and conditionally include it if it exists.

-- 
Jeff Layton <jlayton@redhat.com>
