From: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH] Teach cifs about network namespaces.
Date: Wed, 12 Jan 2011 16:02:51 +0300
Message-ID: <4D2DA67B.1020203@parallels.com>
References: <4D2BDE07.40202@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Kir Kolyshkin <kir-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>,
	"containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org"
	<containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Rob Landley <rlandley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D2BDE07.40202-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

> @@ -1545,6 +1545,10 @@ cifs_find_tcp_session(struct sockaddr *addr, struct smb_vol *vol)
>  
>  	spin_lock(&cifs_tcp_ses_lock);
>  	list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
> +		if (cifs_use_net_ns()
> +		    && cifs_net_ns(server) == current->nsproxy->net_ns)

The netns_eq helper will handle that.
