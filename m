From: David Aldrich <David.Aldrich-R48kc7GjPox+cjeuK/JdrQ@public.gmane.org>
Subject: RE: Sticky bit problem
Date: Mon, 20 Jun 2011 11:15:29 +0100
Message-ID: <0CCCA5445D7FCB4298BBF0739D4FDD5203213E5CDA69@EUEXCLU01.EU.NEC.COM>
References: <0CCCA5445D7FCB4298BBF0739D4FDD52031DBFE7AEAD@EUEXCLU01.EU.NEC.COM>
 <20110617095825.3b097567@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110617095825.3b097567-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Content-Language: en-US
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


> That's actually not the sticky bit, but rather the sgid bit. The capital S means
> that it doesn't have the group execute bit set, which has a special meaning to
> the kernel -- it tells it to enforce mandatory locking. You probably want to use
> the file_mode/dir_mode mount options here.

Thanks very much for your help. It helped us to fix our problem.

David
