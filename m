From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs_get_root shouldn't use path with tree name
Date: Thu, 06 Oct 2016 13:20:41 +0100
Message-ID: <1475756441.2493.4.camel@redhat.com>
References: <1473260003-5271-1-git-send-email-sprabhu@redhat.com>
         <mpsmvjir7hx.fsf@suse.com> <1473698409.29354.3.camel@redhat.com>
         <mpswphl3c7r.fsf@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
To: =?ISO-8859-1?Q?Aur=E9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>,
        linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <mpswphl3c7r.fsf-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 2016-10-06 at 14:15 +0200, Aurélien Aptel wrote:
> What is the status on this?
> 
> If we explicitely ask for a tree name prefix via the new parameter,
> we
> should always get it. It should not return an empty string if there
> is
> no prepath.
> 
> Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:
> > 
> > I suspect that is because the root of the share cannot be a DFS
> > mount.
> > Maybe Steve can confirm it.
> 
> So that means we can safely remove that early return, IIUC.
> 

Aurelien,

I think Steve had requested for a reproducer for this issue. The only
place I've encountered this was with Netapp servers. Do you have a
reproder which works with Samba or Windows servers?

Sachin Prabhu
