export const EnvCard = () => (
    <code style={{ whiteSpace: 'pre-wrap' }}>
        {JSON.stringify((window as any).envInject, null, 2)}
    </code>
);
