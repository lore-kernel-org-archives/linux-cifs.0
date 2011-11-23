From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 2/4] cifs.upcall: always lowercase the hostname
Date: Wed, 23 Nov 2011 09:26:44 -0500
Message-ID: <20111123092644.381e8a8e@tlielax.poochiereds.net>
References: <1322052246-18707-1-git-send-email-jlayton@samba.org>
	<1322052246-18707-3-git-send-email-jlayton@samba.org>
	<20111123130536.GA4143@cobija.connexer.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
To: sean finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111123130536.GA4143-Znhnm/lQSyjxW5zecs3cv0EOCMrvLtNR@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 23 Nov 2011 14:05:36 +0100
sean finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org> wrote:

> On Wed, Nov 23, 2011 at 07:44:04AM -0500, Jeff Layton wrote:
> > Most KDCs are case-sensitive (the notable exception being AD), but DNS
> > is case-insensitive. To prevent admins from having to put in all
> > possible case combinations of a principal, lowercase the hostname prior
> > to trying to get a principal.
> 
> you'll have to excuse my ignorance if i'm missing something, but what
> happens if the pricincpal *is* uppercase on the KDC?
> 
> 	sean

It depends on whether the KDC is case-sensitive. AD is generally not,
so this should work fine there. On a non-AD KDC (e.g. MIT or Heimdal)
it will probably fail.

The idea here is to ensure that we don't have admins adding every
possible case-combination of an SPN in order to handle every possible
case-combination of a hostname.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
