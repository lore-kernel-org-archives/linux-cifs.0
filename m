From: =?UTF-8?Q?Bj=c3=b6rn_Jacke?= <bjacke-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: SFM mapping of \
Date: Wed, 28 Jun 2017 11:50:23 +0200
Message-ID: <942c76b9-5d69-7556-6ff4-79018314f85d@samba.org>
References: <20170601090006.GA21508@SerNet.DE>
 <mps4lw0t5o8.fsf@aaptelpc.suse.de>
 <9c69c458-07a8-cd52-df30-72eb28fde38a@samba.org>
 <CAH2r5msDp046AGiSTXjxfCrkwZoAA7HS7UkhSL8SqAkGaSRP_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: =?UTF-8?Q?Aur=c3=a9lien_Aptel?= <aaptel-IBi9RG/b67k@public.gmane.org>,
        Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msDp046AGiSTXjxfCrkwZoAA7HS7UkhSL8SqAkGaSRP_w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: de-DE
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

On 28.06.2017 07:02, Steve French wrote:
> JRA had some security concerns about allowing \ mapping so we need to
> be careful in deciding how we want Samba to handle that too

I don't really see how the cifs client-side mapping of the "\" character
should affect Samba security here. The client only maps "\" to an
innocent unicode character. The server does nothing with that unicode
character at all. It just stores it as it is - unless you configure via
vfs fruit that you want to convert it to native encoding. But that's
actually nothing that cifs vfs has to worry about. Even without an our
mapping of "\" we can simply create unicode 0xF021 now on a remote SMB
server. And the smb mac clients already do it anyway.

Björn
