From: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH] cifs: use sensible file nlink values if unprovided
Date: Fri, 5 Jul 2013 18:40:31 +0200
Message-ID: <20130705184031.67afd669@f163.suse.de>
References: <1372961186-19213-1-git-send-email-ddiss@suse.de>
	<CAH2r5mtyaufgrOssd872OZzq32TQ8fyprE82aK8FV7MbxceU7g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mtyaufgrOssd872OZzq32TQ8fyprE82aK8FV7MbxceU7g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 4 Jul 2013 14:43:23 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> I merged an equivalent but slightly smaller version of your patch into
> cifs-2.6.git (see below) and added stable since we should not be
> returning nlink of 0.  Let me know if any objections.

Looks good to me Steve.
FWIW, I've been using the following patch to replicate the
NumberOfLinks=0 behaviour on Samba:
http://gitweb.samba.org/?p=ddiss/samba.git;a=commitdiff;h=93c8795c9a9e9f

Cheers, David
