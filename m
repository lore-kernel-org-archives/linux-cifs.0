From: Orion Poplawski <orion-CVdf0l11yl+B+jHODAdFcQ@public.gmane.org>
Subject: Re: pam module to set cifs credentials in key store
Date: Wed, 13 Nov 2013 15:47:19 -0700
Message-ID: <52840177.80901@cora.nwra.com>
References: <loom.20131113T002139-562@post.gmane.org>	 <20131112212536.6061477e@corrin.poochiereds.net>	 <5283E835.2090508@cora.nwra.com> <1384382099.4226.63.camel@pico.ipa.ssimo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Simo <simo-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1384382099.4226.63.camel-fj0lwfvWodpMy5p6ylGyhR2eb7JE58TQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 11/13/2013 03:34 PM, Simo wrote:
>
> Uhm doesn't this code store the user password in the clear in a key that
> is explicitly made readable to any process of the user in the same
> session ?
>
> Simo.
>

I tried to mimic exactly what the cifscreds program does, but I may have made 
a mistake.  Or perhaps cifscreds is also doing a bad thing.  The key 
permissions are set to:

#define CIFS_KEY_PERMS (KEY_POS_VIEW|KEY_POS_WRITE|KEY_POS_SEARCH| \
                         KEY_USR_VIEW|KEY_USR_WRITE|KEY_USR_SEARCH)


-- 
Orion Poplawski
Technical Manager                     303-415-9701 x222
NWRA, Boulder/CoRA Office             FAX: 303-415-9702
3380 Mitchell Lane                       orion-CfuHcwXVrUc@public.gmane.org
Boulder, CO 80301                   http://www.nwra.com
