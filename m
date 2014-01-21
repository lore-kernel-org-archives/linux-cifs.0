From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH v7 1/7] VFS: Introduce new O_DENY* open flags
Date: Tue, 21 Jan 2014 17:19:06 +0400
Message-ID: <CAKywueQhJE5F2t36OyrWBxKvXWagUbs47pUnBRbzRnX2025MKw@mail.gmail.com>
References: <1389953232-9428-1-git-send-email-piastry@etersoft.ru>
	<1389953232-9428-2-git-send-email-piastry@etersoft.ru>
	<20140117181847.6c1f3831@alan.etchedpixels.co.uk>
	<CAKywueT=JsTkNC+w-vrN0ftam7F8Eqb8DXJ0w2G4q9vnt0hVNQ@mail.gmail.com>
	<20140120133424.09328108@alan.etchedpixels.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Linux NFS Mailing list <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	wine-devel-5vRYHf7vrtgdnm+yROfE0A@public.gmane.org
To: One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140120133424.09328108-mUKnrFFms3BCCTY1wZZT65JpZx93mCW/@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

2014/1/20 One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>:
>> > Shouldn't this also check for CAP_SYS_DAC or some similar permission so
>> > that root can override such a mess (eg to fix full disks in an
>> > emergency) ?
>>
>> May be it's better to let root an ability to remount the system
>> without sharelock mount option and then fix an emergency?
>
> Doesn't that involve breaking the service for all users of the system
> relying upon those locks, while root being allowed to ignore the locks
> does not ?

If we allow root to remount without "sharelock" (or bypass conflict
checks), it will definitely break the service for all users. Probably
it's better to stop the service (that cause all sharelocks to be
unlocked), fix the emergency and start the service again.

In the current state, the patchset doesn't allow any sort of ignoring
those locks for mounts with "sharelock" option (either remount without
"sharelock" or set special capabilities). It was done to make sure
nothing breaks applications relying upon sharelock behavior. Also,
that's why "sharelock" mount option was added: this behavior is
dangerous to be on critical system paths like "/" or "/lib" and not
suitable for global use.

-- 
Best regards,
Pavel Shilovsky.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
