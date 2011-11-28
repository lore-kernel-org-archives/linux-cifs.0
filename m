From: jr <creature.eternal-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: problem mounting under Xubuntu
Date: Mon, 28 Nov 2011 20:50:03 +0000
Message-ID: <jb0s5o$v8t$1@dough.gmane.org>
References: <4ED3017A.9030502@gmail.com> <20111128153207.163adbfe@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111128153207.163adbfe-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 28/11/11 20:32, Jeff Layton wrote:
>
> Looks like the tree connect is falling down. Does the user you're
> connecting as have access to the exported share? You may want to check
> the logs on the NAS and see why it's rejecting the tree connect request.
>

looked at logs (via browser) on NetGear NAS, appears not to have been 
recorded.

yes, I can mount the share(s) as '-o guest' from a slackware box, and I 
can access the NAS from xubuntu using smbclient, but using the 
mount.cifs command doesn't work.
