From: simo <idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] cifs-utils: new plugin architecture for ID mapping code
Date: Fri, 07 Dec 2012 10:51:37 -0500
Message-ID: <1354895497.14719.91.camel@pico.ipa.ssimo.org>
References: <1354894216-31870-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1354894216-31870-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 2012-12-07 at 10:30 -0500, Jeff Layton wrote:
> 
> Ok, first "official" posting for the plugin architecture. Changes
> since
> the original RFC set:
> 
> 1/ init_plugin() and exit_plugin() functions have been added to the
>    plugin API. The init passes back an opaque handle so we can
>    potentially use this in threaded programs later if needed.
> 
> 2/ the plugin function names are more distinct, now prefixed with
>    "cifs_idmap_".
> 
> 3/ the code has been changed to never dlclose() the plugin and rely
>    on it to be closed at exit. That makes things a lot simpler...
> 
> Original description follows...

Looks generally good to me, I like where you painted the line between
functionality and complexity :)

Simo.

-- 
Simo Sorce
Samba Team GPL Compliance Officer <simo-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Principal Software Engineer at Red Hat, Inc. <simo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
