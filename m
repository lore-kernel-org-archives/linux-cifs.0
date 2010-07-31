From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 02/18] xstat: Add a pair of system calls to make extended file stats available [ver #6]
Date: Sat, 31 Jul 2010 17:53:32 +0100
Message-ID: <3533.1280595212@redhat.com>
References: <1280524978.2452.9.camel@segv.aura.of.mankind> <alpine.LSU.2.01.1007221228260.6115@obet.zrqbmnf.qr> <20100715021709.5544.64506.stgit@warthog.procyon.org.uk> <20100715021712.5544.44845.stgit@warthog.procyon.org.uk> <30448.1279800887@redhat.com> <E1Obuiy-00C9jr-Al@intern.SerNet.DE> <AANLkTikBCXK6uEw <AANLkTimdFCGSKLn7aGMpBMIauHTsHY7hpAAmpo6uTcnD@mail.gmail.com>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Volker.Lendecke-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org,
	Jan Engelhardt <jengelh-nopoi9nDyk+ELgA04lAiVw@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-fsde-kxMDh+IBDuj1P9xLtpHBDw@public.gmane.org
To: utz lehmann <lkml123-4es5y7D8suKELgA04lAiVw@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1280524978.2452.9.camel-mrvVnycP54q9CgvvYfeeSAlEImK53Lvc@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

utz lehmann <lkml123-4es5y7D8suKELgA04lAiVw@public.gmane.org> wrote:

> When abusing an existing time stamp use atime not ctime please.
> ctime has it's uses. atime was just a mistake and is nearly useless.

CacheFiles currently uses atime to determine least-recently-usedness.

David
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
