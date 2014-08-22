From: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Fwd: [PATCH 1/7] cifs: Bypass windows extended security for
 ntlmv2 negotiate
Date: Thu, 21 Aug 2014 20:41:21 -0700
Message-ID: <20140822034121.GA31938@jeremy-HP>
References: <003401cfbc62$f505f920$df11eb60$@samsung.com>
 <CAH2r5muT0jBfh_K230dtNW5ZkVFx+evHiDA=+yoeG_PvDkCxmA@mail.gmail.com>
Reply-To: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAH2r5muT0jBfh_K230dtNW5ZkVFx+evHiDA=+yoeG_PvDkCxmA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Aug 20, 2014 at 11:51:02PM -0500, Steve French wrote:
> This is an unusual sounding issue.  Any comments on this from the auth experts?
> 
> Seems better to investigate this more if we end up enforcing a "must
> be within 5 minutes" threshold instead of this patch.  Have we done a
> dochelp on this before?

No we have not. I'd feel happier if you could
add some test code to smbtorture that showed
NTLM authentication succeeding with correct time,
and it failing with a large time drift, that
passes against a Windows server.

Jeremy.
