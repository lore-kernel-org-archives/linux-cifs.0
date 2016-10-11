From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] cifs_get_root shouldn't use path with tree name
Date: Tue, 11 Oct 2016 08:18:06 +0200
Message-ID: <mpsk2df2yu9.fsf@suse.com>
References: <1473260003-5271-1-git-send-email-sprabhu@redhat.com> <mpsmvjir7hx.fsf@suse.com> <1473698409.29354.3.camel@redhat.com> <mpswphl3c7r.fsf@suse.com> <1475756441.2493.4.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475756441.2493.4.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:
> I think Steve had requested for a reproducer for this issue. The only
> place I've encountered this was with Netapp servers. Do you have a
> reproder which works with Samba or Windows servers?

The reproducer was for Samba but the root cause was something different
(later fixed by your last DFS fix). The thing I used to reproduce it
doesn't reproduce it anymore.

I have found that the tree name prefix is needed, at least when
mounting. I guess Steve already knew this but it wasn't obvious for me
so I'm sharing it.

When mounting //server/dfsroot/target with 'target' linking to
//server/dfstarget

With tree name prefixed:

=> Trans2 Request, QUERY_PATH_INFO, Query File All Info, Path: //10.160.64.222/dfsroot/target
<= Trans2 Response, QUERY_PATH_INFO, Error: STATUS_PATH_NOT_COVERED

Without tree name prefixed:

=> Trans2 Request, QUERY_PATH_INFO, Query File All Info, Path: /target
<= Trans2 Response, QUERY_PATH_INFO, Error: STATUS_OBJECT_NAME_NOT_FOUND

PATH_NOT_COVERED is mapped to EREMOTE whereas OBJECT_NAME_NOT_FOUND is
mapped to ENOENT.

So *not* prefixing with the tree name actually breaks mounting a path
containing a DFS link in its components. Which is the *opposite* of what
I initially thought. I did not analyze the problem and traces enough,
I'm sorry.

So if we merge this patch, we have to be careful about when to not
prefix the tree name.

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
