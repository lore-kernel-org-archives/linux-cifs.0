From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: Re: cifs running amok after being disconnected (timeout?)
Date: Tue, 28 Feb 2017 11:52:38 +0100
Message-ID: <mpslgsqfuyx.fsf@aaptelpc.suse.de>
References: <58B48122.5000708@tlinx.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
To: L A Walsh <cifs-gT3AUAsYRbTYtjvyW6yDsg@public.gmane.org>, linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <58B48122.5000708-gT3AUAsYRbTYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

L A Walsh <cifs-gT3AUAsYRbTYtjvyW6yDsg@public.gmane.org> writes:
> I tried turning on debug by echoing 1 to /proc/fs/cifs/traceSMB, and that
> "effectively" stopped the conversation, as it was then saturating my
> message log with lines like:

enabling traceSMB just does a hexdump of every packet sent on the
wire. You probably want this:

    echo 1 > /proc/fs/cifs/cifsFYI
    echo 'module cifs +p' > /sys/kernel/debug/dynamic_debug/control
    echo 'file fs/cifs/* +p' > /sys/kernel/debug/dynamic_debug/control

with CONFIG_CIFS_DEBUG, CONFIG_CIFS_DEBUG2, CONFIG_DYNAMIC_DEBUG enabled.


> Any idea what might have been going on?  Anything better tracing
> options to determine what was going on?

As you said it seems the server keeps reseting the tcp connexion. A full
trace starting from the initial mount will help.

You should be able to open a bug on either samba on the kernel
bugtracker and attach traces there.

Have you tried to mount using a newer protocol (2.1 or 3.0)? (using
e.g. -o vers=2.1)

Cheers,

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
