From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v1 1/1] fs/cifs/dir.c: use correct path separators
Date: Sat, 17 Sep 2016 09:54:38 +0200
Message-ID: <mpswpibklkx.fsf@suse.com>
References: <1473255952-27579-1-git-send-email-aaptel@suse.com> <1473705389.29354.20.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473705389.29354.20.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:
> We have an inline helper convert_delimiter() which already does this.
> The block for dfsplen also seems to repeat the code. 

Correct except for a small detail: the inline helper does the conversion
until the end of the string. Here we need to stop in the middle.

> Can we use the  helper for the complete patch instead when the
> full_path variable is available?

We do not want to mess with unix path that might contain a valid
backslash inside a path component.

> I think the code here for copying the treename and the prefixpath name
> can also be cleaned to make it easier to read ie. move the treeName
> copy before we copy over the prefix path.

Agreed. Thanks for the feedback, Sachin.
I'll send an updated patch for review.

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
