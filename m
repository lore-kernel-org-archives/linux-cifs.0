From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: Use mask of ACEs for SID Everyone to calculate
 all three permissions user, group, and other
Date: Sat, 15 Jan 2011 19:59:13 -0500
Message-ID: <20110115195913.00ada69b@tlielax.poochiereds.net>
References: <1291669006-12102-1-git-send-email-shirishpargaonkar@gmail.com>
	<20110104141130.2cec2a74@tlielax.poochiereds.net>
	<AANLkTikhkFnU0B+0JbUXwZvOfVdY_XB67oEaiyaajT0H@mail.gmail.com>
	<20110104143122.46627c31@tlielax.poochiereds.net>
	<AANLkTimT4AKX0HYCMcZiMXvXV-N0r23yGQ+oU=CDdi-w@mail.gmail.com>
	<20110104150934.3ba10652@tlielax.poochiereds.net>
	<AANLkTik38rcit3PJc1d0WU7+kS4a39UTaQ6TuRN+H_if@mail.gmail.com>
	<20110113104834.1583ec39@barsoom.rdu.redhat.com>
	<AANLkTin6t6qoQe7weUkKwNHBPvXkSEbQ9-b16+5A_HpE@mail.gmail.com>
	<20110114100843.2d6b5dbb@tlielax.poochiereds.net>
	<AANLkTim+=AuC3XabiFpGUKsVyFug4PtP-LhXyysSwp7_@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTim+=AuC3XabiFpGUKsVyFug4PtP-LhXyysSwp7_-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 14 Jan 2011 23:01:12 -0600
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> 
> Jeff, Thanks. Need to think this over.
> 
> Wish there were a commands/subcommands like getpathinfo
> and gethandleinfo with infolevels to determine what functions
> GetEffectiveRightsFromAcl and AccessCheckByType provide.
> 
> Perhaps these are Windows APIs providing these type of services
> and there is a named pipe providing these services.

Even if there were, there would be nothing preventing the access rights
from changing after you fetch the permissions but before you enforce
them. That's a situation that can't be prevented if you're relying on
the client to enforce permissions.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
