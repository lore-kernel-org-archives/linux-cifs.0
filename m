From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: smbcmp: new tool to compare SMB traces
Date: Wed, 01 Feb 2017 15:33:54 +0530
Message-ID: <1485943434.11784.23.camel@redhat.com>
References: <mpspoj3jrtv.fsf@aaptelpc.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
To: =?ISO-8859-1?Q?Aur=E9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>,
        linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <mpspoj3jrtv.fsf-zpEvHKhluMwYitT5tn2FcQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 2017-01-31 at 14:13 +0100, Aurélien Aptel wrote:
> Hi,
> 
> I've written a small utility to diff and compare SMB network
> captures. It's a simple python script that uses tshark to filter and
> dissect SMB packets, with a curses UI.
> 
> https://github.com/aaptel/smbcmp
> 
> There is a gif demo on there, if you're into that.
> 
> Enjoy,
> 

Interesting. How easy is it to extend this for NFS?

Sachin Prabhu
