From: Bernhard Walle <bernhard@bwalle.de>
Subject: Re: [PATCH] cifs: Add information about noserverino
Date: Mon, 06 Dec 2010 16:35:06 +0100
Message-ID: <20101206163506.56232lqqhc5c3co4@webmail.df.eu>
References: <1291568855-22604-1-git-send-email-bernhard@bwalle.de>
	<20101206095725.78422138@tlielax.poochiereds.net>
	<20101206101214.52a24415@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Cc: sfrench@samba.org, samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org, linux-cifs@vger.kernel.org
To: Jeff Layton <jlayton@redhat.com>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <20101206101214.52a24415@tlielax.poochiereds.net>
Content-Disposition: inline
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


Zitat von Jeff Layton <jlayton@redhat.com>:

>
> I'm still not sure I like this patch however. It potentially means a
> lot of printk spam since these things have no ratelimiting. It also
> doesn't tell me anything about which server might be giving me grief.
>
> Maybe this should be turned into a cFYI?

Well, if I see it in the kernel log, it doesn't matter if it's info or
something else.

> The bottom line though is that running 32-bit applications that were
> built without -D_FILE_OFFSET_BITS=64 on a 64-bit kernel is a very bad
> idea. It would be nice to be able to alert users that things aren't
> working the way they expect, but I'm not sure this is the right place
> to do that.

Well, but there *are* such application (in my case it was Softmaker Office
which is a proprietary word processor) and it's quite nice if you know
how you can workaround it when you encounter such a problem. That's all.


Regards,
Bernhard
